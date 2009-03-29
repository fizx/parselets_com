class Message < ActiveRecord::Base
  belongs_to :from_user, :class_name => 'User'
  belongs_to :to_user, :class_name => 'User'
  
  validates_each :from_user_id, :to_user_id do |record, attribute, value|
    record.errors.add attribute, 'is not a valid user.' unless value && User.find_by_id(value)
  end
  
  validates_length_of :subject, :within => 2...100
  validates_length_of :text, :within => 1...1024
  
  def read!
    self.read_at = Time.now
    save!
  end
end
