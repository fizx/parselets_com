require "rubygems"
require "ordered_json"
require "digest/md5"
class Parselet < ActiveRecord::Base
  module ClassMethods
    def top(n = 5)
      find :all, :limit => n
    end
  
    def tmp_from_params(params)
      raise "wtf" unless params.is_a?(Hash)
      tmp = Parselet.new
      tmp.data = value_of params
      tmp
    end

  private

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
          memo[pair["key"]] = val
          memo
        end
      end
    end
  end
  extend ClassMethods
  
  def code
    self[:code] || "{}"
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
