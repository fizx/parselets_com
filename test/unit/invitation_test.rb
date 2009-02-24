require 'test_helper'
require "digest/md5"

class InvitationTest < ActiveSupport::TestCase
  def setup
    @invite = invitations(:one)
  end
  
  def test_max_usage
    assert_equal 1, @invite.usages
    assert_equal 0, @invite.used
    
    u = new_user
    u.invitation = @invite
    assert u.valid?
    u = User.create :login => "barbar", :email => "bar@bar.com", :password => "what"
    u.invitation = @invite
    assert !u.valid?
  end
  
  def new_user
    pwd = rand_str
    User.new :login => rand_str, :email => "#{rand_str}@bar.com", :password => pwd, :password_confirmation => pwd
  end
  
  def rand_str(len = 8)
    Digest::MD5.hexdigest(rand.to_s).first(len)
  end
end
