require File.dirname(__FILE__) + '/user/auth'

class User < ActiveRecord::Base
  def self.top(n = 5)
    find :all, :limit => n
  end
end
