class Sprig < ActiveRecord::Base
  acts_as_versioned
  acts_as_paranoid
  
  def self.top(n = 5)
    find :all, :limit => n
  end
end
