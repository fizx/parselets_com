require "rubygems"
require "parsley"
require "ordered_json"
require "digest/md5"
require "open-uri"
require "cgi"

class InvalidStateError < RuntimeError; end

class Parselet < ActiveRecord::Base  
  TAB = " " * 2
  acts_as_paranoid
  include CustomValidations  

  # FIXME: grouping on versions
  is_indexed :fields => ["name", "description", "code"],
    :include => [
      {:association_name => 'user', :field => 'login'},
      {:association_name => 'domain', :field => 'variations'}
    ],
    :conditions => "parselets.deleted_at IS NULL AND user_id IS NOT NULL",
    :order => "parselets.updated_at DESC", :delta => true
  
  belongs_to :user
  belongs_to :domain
  has_many :comments,   :as => :commentable
  has_many :ratings,    :as => :ratable
  has_many :favorites,  :as => :favoritable
  
  belongs_to :cached_page
  
  validates_uniqueness_of :name, :scope => :version
  validates_format_of :name, :with => /\A[a-z0-9\-_]*\Z/, :message => "contains invalid characters"
  
  validates_format_of :name, :with => /[^0-9]/, :message => "cannot be entirely numeric"
  validates_presence_of :name, :description, :code, :pattern, :example_url, :user_id
  validates_json :code
  validates_example_url_matches_pattern
  
  before_save :create_domain, :unless => :ignoring_callbacks?
  before_save :calculate_signature, :unless => :ignoring_callbacks?
  before_save :update_cached_page, :unless => :ignoring_callbacks?
  before_save :update_score_and_best_version, :unless => :ignoring_callbacks?
  
  
  SCORE_UPDATE_SQL = <<-SQL
      score = (
        (5.0 * sqrt(`parselets`.id)) + 
        (100 * `parselets`.works) + 
        (1.0 * IFNULL((SELECT ((sum(ratings.score) + 15) / (count(ratings.id) + 5)) FROM ratings 
                       WHERE ratings.ratable_id=parselets.id and ratings.ratable_type='Parselet'), 0)) +
        (1.0 * `parselets`.comments_count) + 
        (1.0 * (SELECT count(1) from favorites where favorites.favoritable_id=parselets.id and favorites.favoritable_type='Parselet'))
      )
    SQL
  
  def update_score_and_best_version
    Parselet.ignoring_callbacks do
      Parselet.update_all 'best_version = 0', ['name = ?', name]
      Parselet.update_all SCORE_UPDATE_SQL, ['name = ? and version = ?', name, version]
      best_version = Parselet.find(:first, :order => 'score desc', :conditions => { :name => name })
      if best_version
        best_version.best_version = true
        best_version.save(false)
      else
        # This is the first parselet with this name, must be new.
        self.best_version = true
      end
    end
  end
  
  def update_cached_page
    begin
      self.cached_page = CachedPage.find_or_create_by_url(example_url)
    rescue Exception => e
      logger.error "ERROR: Unable to update_cached_page: #{e.message}\n#{e.backtrace.join("\n")}\n"
    end
  end
  
  def create_domain
    self.domain = Domain.from_url(example_url)
  end
  
  def original
    Parselet.find(:first, :conditions => {:name => name}, :order => "version ASC")
  end
  
  def original_user_id
    original && original.user_id
  end
  
  def comments_across_versions_count
    Parselet.sum(:comments_count, :conditions => ['name = ?', name])
  end
  
  def calculate_signature
    begin
      keys = recurse_signature(data)
      self.signature = keys.sort.join(" ")
    rescue OrderedJSON::ParseError => e
      logger.error "ERROR: #{e.message}\n#{e.backtrace.join("\n")}\n"
    end
  end
  
  def summary
    [ ["Keyword", name], 
      ["Description", description], 
      ["Pattern", pattern], ["Example Url", example_url], 
      ["Code", pretty_code]].map {|title, content|
        %[{{{#{title}}}}\n#{content}\n\n]
      }.join("").strip
  end

  def recurse_signature(object, path = "")
    case object
    when Hash:
      object.map do |k, v|
        k = k.split("(").first
        recurse_signature v, path + "/#{k}"
      end.flatten
    when Array:
      object.map do |e|
        recurse_signature e, path + "/"
      end
    when String:
      path
    end
  end

  def to_param
    name
  end

  def login
    user && user.login
  end

  def average_rating
    cached_rating || 0
  end

  def pattern_valid?
    pattern_tokens
    true 
  rescue InvalidStateError => e
    false
  end

  def status
    if !checked_at?
      "unknown"
    elsif !works?
      "broken"
    elsif checked_at < 1.day.ago
      "stale"
    else
      "ok"
    end
  end

  def domain_name
    domain && domain.name
  end

  def check
    if !checked_at || checked_at < 1.day.ago
      example_data
      STDERR.print "."
      STDERR.flush
    end
  end

  def url
    example_url
  end

  def sanitized_code
    OrderedJSON.dump(sanitize(json))
  end

  def sanitize(obj)
    case obj
    when Hash, OrderedHash:
      obj.inject(OrderedHash.new) do |m, (k, v)|
        m[k] = sanitize(v) unless k.blank? || v.blank?
        m
      end
    when Array
      obj.map {|e| sanitize(e)}
    else
      obj
    end
  end

  def example_data(url = nil)
    @cached_example_data ||= {}
    @cached_example_data[url] ||= example_data_uncached(url)
  end

  def example_data_uncached(url = nil)
    logger.info url.inspect
    url ||= example_url
    return {} if url.blank?
    content = CachedPage.find_or_create_by_url(url).content
    out = Parsley.new(sanitized_code).parse(:string => content, :output => :json)
    answer = OrderedJSON.parse(out)
    set_working true
    @example_data = answer
    answer
  rescue ParsleyError, OrderedJSON::ParseError, OrderedJSON::DumpError => e
    set_working false
    {"errors" => e.message.split("\n")}
  end

  def zipped_example
    JsonZip.zip(data, example_data)
  end

  def parse(url, options = {})
    return {} if url.nil? || url !~ /^http:\/\//i
    content = CachedPage.find_or_create_by_url(url).content
    OrderedJSON.parse Parsley.new(sanitized_code).parse(:string => content, :output => options[:output] || :json)
  rescue ParsleyError, OrderedJSON::ParseError, OrderedJSON::DumpError => e
    {"errors" => e.message.split("\n")}
  end

  def pretty_parse(url, options = {})
    OrderedJSON.pretty_dump(parse(url, options)).gsub("\t", TAB)
  end

  def set_working(val)
    Parselet.send(:with_exclusive_scope) do
      self.works = val
      self.checked_at = Time.now
      save!
    end
  end

  def pretty_example_data(url = nil)
    OrderedJSON.pretty_dump(example_data(url)).gsub("\t", TAB)
  end

  def compressed_html_example_data(url = nil)
    Parselet.compress_json(CGI::escapeHTML(pretty_example_data(url)))
  end

  def pattern_tokens
    state = [:url]
    str = ""
    keys = []
    url_chunks = []
    pattern.each_char do |c|
      if state.last == :escaping
        str += c
        state.pop
      elsif c == "\\"
        state << :escaping
      elsif c == "{"
        assert_state state, :url
        url_chunks << str
        str = ""
        state[-1] = :key
      elsif c == "}"
        assert_state state, :key
        keys << str
        str = ""
        state[-1] = :url
      else
        str += c
      end
    end  
    assert_state state, :url
    url_chunks << str
    [url_chunks, keys]
  end
  
  def pattern_keys
    pattern_tokens[1]
  end
  
  def pretty_example_url
    url_chunks, keys = pattern_tokens
    # puts url_chunks.inspect
    re = Regexp.compile url_chunks.reject(&:blank?).map{|c| Regexp.escape(c)}.join("|")
    
    # puts re.inspect
    wiki = CGI::escapeHTML(example_url.gsub(re, ']]\0[[')[2..-1] + "]]")
    wiki.gsub("[[", "<b>").gsub("]]", "</b>")
  end

  # Helper used by pattern_tokens
  def assert_state(state, value)
    raise InvalidStateError.new unless state[-1] == value
  end

  def pattern_matches?(url)
    return false if url.blank? || !pattern_valid?
    url_chunks, _ = pattern_tokens
    url_chunks.map!{|str| Regexp.escape(str) }
    re = Regexp.new("\\A" + url_chunks.join(".*?") + "\\Z")
    re === url.to_s
  end

  # Used in dev display code.
  def pick_example_element(data = nil)
    if data.nil?
      if example_data && !example_data['errors']
        return pick_example_element(example_data)
      else
        return ['', '']
      end
    end
    count = 0
    data.each do |*item|
      if data.is_a?(Hash)
        key = item.first
        value = item.last
        element = "['#{key}']"
      elsif data.is_a?(Array)
        value = item.first
        element = "[#{count}]"
      end
      if value
        if value.is_a?(Array) || value.is_a?(Hash)
          next_element, last_value = pick_example_element(value)
          return [element + next_element, last_value]
        else
          return [element, value.to_s]
        end
      end
      count += 1
    end
    return ['', '']
  end

  def code
    self[:code].blank? ? "{}" : self[:code]
  end

  def pretty_code
    OrderedJSON.pretty_dump(OrderedJSON.parse(code)).gsub("\t", TAB)
  end

  def json
    OrderedJSON.parse(code)
  end
  alias_method :data, :json

  def json=(obj)
    self.code = OrderedJSON.dump(obj)
  end
  alias_method :data=, :json=

  def guid
    id || "new-#{Digest::MD5.hexdigest(rand.to_s)[0..6]}"
  end
  
  def clone_to_new_version(user)
    new_attributes = attributes.keys - ["id", "works", "cached_rating", "user_favorited", "score", "best_version"]
    new_attributes.delete_if {|i| i =~ /_count$/ || i =~ /_at$/ }
    new_version = Parselet.new
    new_attributes.each { |key| new_version.send("#{key}=", send(key)) }
    new_version.version = highest_version + 1
    new_version.user = user
    new_version
  end
  
  def highest_version
    Parselet.maximum(:version, :conditions => ['name = ?', name])
  end
  
  def versions
    Parselet.find :all, :conditions => { :name => name }, :order => '`parselets`.version desc'
  end

  def paginated_versions(params = {})
    Parselet.paginate Parselet.symbolize_hash(params).merge( :conditions => { :name => name }, :order => '`parselets`.version desc' )
  end
  
  def ignoring_callbacks?
    Parselet.ignoring_callbacks?
  end
    
  # Class Methods

  ALLOWED_OPTIONS = %w[order group having limit offset from readonly lock page per_page total_entries count finder].map(&:to_sym)
  
  def self.advanced_find(number, options = {}, more_options = {})
    options = symbolize_hash(options).merge(symbolize_hash more_options)
    
    include_favs = nil
    include_favs_select = ''
    if favorite_user = options.delete(:favorite_user)
      include_favs = " LEFT JOIN favorites on parselets.id=favorites.favoritable_id and favorites.user_id=#{favorite_user.id.to_i}"
      include_favs_select = ", favorites.id as user_favorited"
    end

    conditions = ['best_version = 1']

    user = options.delete(:user) || options.delete(:user_id)
    if user && user = User.find_by_params(user)
      conditions[0] += ' and `parselets`.user_id = ?'
      conditions << user.id
    end
  
    if favorited = options.delete(:favorited) && favorited != 'false' && favorited != '0' && favorite_user
      conditions[0] += ' and `favorites`.id is not null'
    end
    
    show_broken = options.delete(:show_broken)
    unless show_broken && show_broken != 'false' && show_broken != '0'
      conditions[0] += ' and `parselets`.works=1'
    end

    id = options.delete(:id) || options.delete(:parselet) || options.delete(:parselet_id)
    if id.to_s =~ /\A\d+\Z/
      conditions[0] += ' and `parselets`.id = ?'
      conditions << id.to_i
    elsif id
      conditions[0] += ' and `parselets`.name = ?'
      conditions << id
    end
    
    version = options.delete(:version) || options.delete(:parselet_version)
    if version
      conditions[0] += ' and `parselets`.version = ?'
      conditions << version.to_i
    end

    whitelisted_options = options.inject({}) {|m, (k, v)| m[k] = v if ALLOWED_OPTIONS.include?(k); m}

    options = { :order => 'score desc', :conditions => conditions, :select => "`parselets`.*" + include_favs_select, 
                :joins => include_favs 
              }.merge(whitelisted_options)

    if options.delete(:paginate) || number == :paginate
      paginate({ :per_page => 10 }.merge(options))
    else
      find number, options
    end
  end
  
  def self.find_by_params(params = {}, more_params = {})
    params = symbolize_hash(params).merge(symbolize_hash more_params)
    version = params[:version] || params[:parselet_version]
    result = version ? nil : advanced_find(:first, params)
    if result
      result
    else
      id = params[:id] || params[:parselet] || params[:parselet_id]
      if id.to_s =~ /\A\d+\Z/
        find_by_id_and_version(id, version || 1)
      else
        find_by_name_and_version(id, version || 1)
      end
    end
  end
  
  def self.compress_json(data, allowed = 2, base_id = "hidden")
    i = 0
    out = []
    lines = data.split("\n")
    array_stack = OrderedHash.new
    lines.each do |line|
      level = line[/^(\s)*/].length / TAB.length
      if line =~ /\[\s*$/
        array_stack[level] = 0
      elsif line =~ (/\],?\s*$/)
        out.last << "</span>"
        array_stack.delete(array_stack.keys.last)
      elsif line =~ /,\s*$/
        if array_stack[level - 1]  # stack = array_stack[level - 1] || array_stack[level - 2]
          array_stack[level - 1] += 1
          if array_stack[level - 1] == allowed
            i += 1
            id = "#{base_id}-#{i}"
            line += %[<a href="javascript:void(jQuery('##{id}').toggle())">more...</a><span style="display:none" id="#{id}">]
          end
        end
      end
      out << line
    end
    return out.join("\n")
  end

  def self.tmp_from_params(params = {})
    tmp = Parselet.new(params[:parselet])
    tmp
  end
  
  def self.symbolize_hash(hash)
    hash.inject({}) {|m, (k, v)| m[k.to_sym] = v; m}
  end
  
  def self.ignoring_callbacks
   tmp = @ignore_callbacks
   @ignore_callbacks = true
   yield
  ensure
   @ignore_callbacks = tmp
  end

  def self.ignoring_callbacks?
   !!@ignore_callbacks
  end
end
