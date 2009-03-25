class Karma < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user, :description
  validates_numericality_of :value
end
