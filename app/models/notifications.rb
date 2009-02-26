class Notifications < ActionMailer::Base

  def temporary_login(user)
    subject    'Your temporary login'
    recipients user.email
    from       'no-reply@parselets.com'
    sent_on    Time.now
    
    body       :user => user
  end

end
