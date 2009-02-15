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
          memo[pair["key"]] = val unless pair["deleted"] == "true"
          memo
        end
      end
    end
  end
  extend ClassMethods
  
  def code=(str)
    OrderedJSON.parse(str)
    self[:code] = str
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
