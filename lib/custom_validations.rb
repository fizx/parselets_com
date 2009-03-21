require "json"
require "uri"
module CustomValidations
  module ClassMethods
    def validates_json(*args)
      validates_each(*args) do |record, name, value|
        begin
          JSON.parse(value)
        rescue
          record.errors.add :name, "is not valid JSON"
        end
      end
    end
    
    def validates_uri(*args)
      validates_each(*args) do |record, name, value|
        begin
          URI.parse(value)
        rescue => e 
          record.errors.add :name, "is not valid URI: #{e.message}"
        end
      end
    end
    alias_method :validates_url, :validates_uri
    
    def validates_example_url_matches_pattern
      validates_each(:pattern) do |record, name, value|
        unless record.pattern_matches?(record.example_url)
          record.errors.add :example_url, "doesn't match the pattern."
        end
      end
    end
  end
  
  def self.included(klass)
    klass.extend(ClassMethods)
  end
end