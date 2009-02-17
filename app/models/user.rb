require File.dirname(__FILE__) + '/user/auth'

class User < ActiveRecord::Base
  module ClassMethods
    def top(n = 5)
      find :all, :limit => n
    end
    
    def find_by_key(key)
      find_by_login(key)
    end
  end
  extend ClassMethods
  
  has_many :sprigs
  has_many :parselets
  is_indexed :fields => %w[login name], :delta => true
end
