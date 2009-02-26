class Notifications < ActionMailer::Base
  

  def forgot_password(user)
    subject    'Your password reset'
    recipients user.email
    from       'no-reply@parselets.com'
    sent_on    Time.now
    
    body       :user => user
  end

end
