require File.dirname(__FILE__) + '/user/auth'

class User < ActiveRecord::Base
  module ClassMethods
    def top(n = 5)
      find :all, :limit => n
    end

    def find_by_api_key(key)
      login, pwd = key.split("-")
      u = find_by_login(login)
      u && u.crypted_password[0..8] && u
    end
  end
  extend ClassMethods
  
  has_many :sprigs
  has_many :parselets
  belongs_to :invitation
  
  is_indexed :fields => %w[login name], :delta => true
  
  validates_each :invitation, :on => :create do |record, _, _|
    unless record.invitation_usable?
      record.errors.add :invitation, "is no longer valid"
    end
  end
  
  def api_key
    "#{login}-#{crypted_password[0..8]}"
  end
  
  def to_param
    login
  end
  
  def invitation_usable?
    invitation && invitation.usable?
  end
  
  def key
    self[:login]
  end
end
