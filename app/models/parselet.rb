require "rubygems"
require "dexterous"
require "ordered_json"
require "digest/md5"
require "open-uri"
class InvalidStateError < RuntimeError; end
class Parselet < ActiveRecord::Base  
  module ClassMethods
    def top(n = 5)
      find :all, :limit => n
    end
  
    def tmp_from_params(params)
      tmp = Parselet.new(params[:parselet])
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
  
  belongs_to :user
  belongs_to :domain
  
  validates_uniqueness_of :name
  validates_format_of :name, :with => /\A[a-z0-9\-_]*\Z/, :message => "contains invalid characters"
  validates_presence_of :name, :description, :code, :pattern, :example_url, :user_id
  validates_json :code
  validates_example_url_matches_pattern
  
  before_save :create_domain
  
  def create_domain
    self.domain = Domain.from_url(example_url)
  end
  
  def pattern_valid?
    pattern_tokens
    true 
  rescue InvalidStateError => e
    false
  end
  
  def example_data
    return {} if example_url.nil?
    content = CachedPage.content_by_url(example_url)
    out = Dexterous.new(code).parse(:string => content, :output => :json)
    OrderedJSON.parse(out)
  # rescue => e
  #   {"errors" => e.message.split("\n")}
  end
  
  def pretty_example_data
    OrderedJSON.pretty_dump(example_data).gsub("\t", "    ")
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
    OrderedJSON.pretty_dump(OrderedJSON.parse(code)).gsub("\t", "    ")
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
