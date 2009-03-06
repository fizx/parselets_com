require "rubygems"
require "parsley"
require "ordered_json"
require "digest/md5"
require "open-uri"
class InvalidStateError < RuntimeError; end
class Parselet < ActiveRecord::Base  
  TAB = " " * 2
  
  module ClassMethods
    def top(n = 5)
      find :all, :conditions => {:works => true}, :limit => n, :order => "updated_at DESC"
      find_by_sql <<-SQL
        select parselets.*, count(ratings.id) as cnt, (sum(ratings.score) + 15) / (count(ratings.id) + 5) as avg from parselets left join ratings on parselets.id=ratings.ratable_id and ratable_type='Parselet' where works = 1 group by parselets.id order by avg DESC LIMIT 5
      SQL
    end
    
    def find_by_params(params = {})
      if params[:id] =~ /\A\d+\Z/
        find(params[:id])
      else
        find_by_name(params[:id])
      end
    end
    alias_method :find_from_params, :find_by_params
    
    def compress_json(data, allowed = 2, base_id = "hidden")
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
              line += %[<a href="javascript:$('#{id}').toggle()">more...</a><span style="display:none" id="#{id}">]
            end
          end
        end
        out << line
      end
      return out.join("\n")
    end
  
    def tmp_from_params(params = {})
      tmp = Parselet.new(params[:parselet] || params[:parselet_version])
      if root = params[:root]
        command = params[:"root-command"]
        apply_command!(root, command) unless command.blank?
        raise "wtf" unless root.is_a?(Hash)
        tmp.data = value_of root
      end
      tmp
    end
    
    def validates_example_url_matches_pattern
      validates_each(:pattern) do |record, name, value|
        unless record.pattern_matches?(record.example_url)
          record.errors.add :example_url, "doesn't match the pattern."
        end
      end
    end

  private
  
    def apply_command!(params, command)
      path, i, command = command.split(",")
      node = address_path(params, path, i)
      case command      
      when "delete":
        node && node["deleted"] = "true"
      when "multify":
        node && node["multi"] = "true"
      when "unmultify":
        node && node["multi"] = nil
      when "unobjectify":
        node && node["value"] = nil
      when "objectify":
        v = node["value"]
        node["value"] = {
          "0" => {
            "key" => "",
            "value" => v
          }
        }
      end
    end
    
    def address_path(params, path, i)
      keys = path.scan(/\[([^\]\[]+)\]/).flatten + [i]
      keys.inject(params){|memo, key| (memo || {})[key] }
    end

    def value_of(data)
      case data
      when Array:       [value_of(data[0])]
      when "!array":    []
      when "!hash":     OrderedHash.new
      when String:      data
      when NilClass:     ""
      when Hash:        
        data.keys.sort_by(&:to_i).inject(OrderedHash.new) do |memo, key|
          pair = data[key]
          val = value_of(pair["value"])
          val = [val]           if pair["multi"] == "true"
          val = []              if val == [nil]
          unless pair["deleted"] == "true" || (pair["key"].blank? && val.blank?)
            memo[pair["key"]] = val 
          end
          memo
        end
      end
    end
  end
  
  extend ClassMethods
  include CustomValidations
  
  acts_as_versioned
  acts_as_paranoid
  
  is_indexed :fields => ["name", "description"],
    :include => [
      {:association_name => 'user', :field => 'login'},
      {:association_name => 'domain', :field => 'variations'}
    ],
    :conditions => "parselets.deleted_at IS NULL AND user_id IS NOT NULL",
    :order => "parselets.updated_at DESC", :delta => true
    
  belongs_to :revision_user, :class_name => "User"
  belongs_to :user
  belongs_to :domain
  has_many :comments, :as => :commentable
  has_many :ratings, :as => :ratable
  
  belongs_to :cached_page
  
  # validates_each(:cached_changes) do |r, a, v|
  #     r.errors.add("", "Try changing something.") if v == "none"
  #   end
  
  validates_uniqueness_of :name
  validates_format_of :name, :with => /\A[a-z0-9\-_]*\Z/, :message => "contains invalid characters"
  
  validates_format_of :name, :with => /[^0-9]/, :message => "cannot be entirely numeric"
  validates_presence_of :name, :description, :code, :pattern, :example_url, :user_id
  validates_json :code
  validates_example_url_matches_pattern
  
  before_save :create_domain
  before_save :calculate_signature
  before_save :calculate_changes
  before_save :update_cached_page
  
  class Version < ActiveRecord::Base
    belongs_to :user
    belongs_to :revision_user, :class_name => "User"
    belongs_to :cached_page
  end
  
  # Get included into Parselet::Version later
  module VersionableMethods
    
    def calculate_changes
      changes = []
      pid = is_a?(Version) ? parselet_id : id
      old_version = version - 1 
      unless old = Parselet::Version.find_by_parselet_id_and_version(pid, old_version)
        return self.cached_changes = "created"
      end
      
      {
        "signature" => "structure",
        "code" => "code",
        "name" => "keyword",
        "description" => "description",
        "pattern" => "pattern", 
        "example_url" => "example url"
      }.each do |method, text|
        if(old.send(method) != self.send(method))
          changes << text
        end
      end
      self.cached_changes = "none"
      self.cached_changes = changes.join(" ") unless changes.blank?
      
    end
    
    def calculate_signature
      keys = recurse_signature(data)
      self.signature = keys.sort.join(" ")
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
    
    def update_cached_page
      self.cached_page = CachedPage.find_or_create_by_url(example_url)
    end
    
    def create_domain
      self.domain = Domain.from_url(example_url)
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

    def example_data
      return {} if example_url.blank?
      content = (cached_page || update_cached_page).content
      out = Parsley.new(sanitized_code).parse(:string => content, :output => :json)
      answer = OrderedJSON.parse(out)
      set_working true
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
      Parsley.new(sanitized_code).parse(:string => content, :output => options[:output] || :json)
    rescue ParsleyError, OrderedJSON::ParseError, OrderedJSON::DumpError => e
      {"errors" => e.message.split("\n")}
    end

    def set_working(val)
      Parselet.send(:with_exclusive_scope) do
        self.works = val
        self.checked_at = Time.now
        respond_to?(:save_without_revision) ? save_without_revision : save
      end
    end

    def pretty_example_data
      OrderedJSON.pretty_dump(example_data).gsub("\t", TAB)
    end
    
    def compressed_html_example_data
      Parselet.compress_json(CGI::escapeHTML(pretty_example_data))
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
  end
  include VersionableMethods
  Version.send(:include, VersionableMethods)
  
end
