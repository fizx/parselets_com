class Invitation < ActiveRecord::Base
  module ClassMethods
    def usable?(code)
      i = find_by_code(code)
      i && i.usable?
    end
  end
  extend ClassMethods
  
  has_many :users
  belongs_to :user
  validates_numericality_of :usages, :greater_than => 0, :only_integer => true
  validates_length_of :code, :in => 4..12
  
  def usable?
    used < usages
  end
  
  def used
    users.count
  end
end
