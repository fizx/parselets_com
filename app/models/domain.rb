require "facets/set"
class Domain < ActiveRecord::Base
  module ClassMethods
    def top(n = 5)
      find :all, :limit => n
    end
    
    def create_from_url(url)
      host = URI.parse(url).host
      create(:name => host)
    end
  end
  extend ClassMethods
  
  validates_presence_of :name
  before_save :create_variations
  
  def create_variations
    self.variations = "www.#{name}".split(".").power_set.map{|e| e.join(".") }.join(" ")
  end
end
