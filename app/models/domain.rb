class Domain < ActiveRecord::Base
  def self.top(n = 5)
    find :all, :limit => n
  end
end
