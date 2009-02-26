class PasswordRequest < ActiveRecord::Base
  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  validates_each :email do |rec, attr, val|
    unless User.find_by_email(val)
      rec.errors.add(:email, "doesn't exist in the system")
    end
  end
  
  before_create :send_email
  
  def user
    User.find_by_email(email)
  end
  
  def send_email
    Notifications.deliver_temporary_login(user)
    self.sent_at = Time.now
  end
end
