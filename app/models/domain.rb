require "facets/set"
class Domain < ActiveRecord::Base
  module ClassMethods
    def top(n = 5)
      find :all, :limit => n
    end
    
    def from_url(url)
      host = URI.parse(url).host
      find_or_create(:name => host)
    end
  end
  extend ClassMethods
  
  has_many :domains
  validates_presence_of :name
  before_save :create_variations
  is_indexed :fields => %w[name variations], :delta => true
  
  def create_variations
    self.variations = "www.#{name}".split(".").power_set.map{|e| e.join(".") }.join(" ")
  end
end
