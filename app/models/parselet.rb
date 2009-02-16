require "rubygems"
require "ordered_json"
require "digest/md5"
class Parselet < ActiveRecord::Base  
  module ClassMethods
    def top(n = 5)
      find :all, :limit => n
    end
  
    def tmp_from_params(params, command = nil)
      apply_command!(params, command) unless command.blank?
      raise "wtf" unless params.is_a?(Hash)
      tmp = Parselet.new
      tmp.data = value_of params
      tmp
    end
    
    def validates_example_url_matches_pattern
      validates_each(:pattern) do |record, name, value|
        unless record.pattern_regex?
          value = '\A' + Regexp.escape(value).gsub("\\*", "(.*?)") + '\Z'
        end
        unless record.example_url =~ Regexp.new(value)
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
  
  validates_uniqueness_of :name
  validates_format_of :name, :with => /\A[a-z0-9\-_]*\Z/, :message => "contains invalid characters"
  validates_presence_of :name, :description, :code, :pattern, :example_url, :user_id
  validates_json :code
  validates_example_url_matches_pattern
  
  after_save :create_domain
  
  def create_domain
    Domain.create_from_url(example_url)
  end
  
  def code
    self[:code].blank? ? "{}" : self[:code]
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
