require File.dirname(__FILE__) + '/user/auth'

class User < ActiveRecord::Base
  module ClassMethods
    def top(n = 5)
      find_by_sql "SELECT users.*, COUNT(parselet_versions.id) as p FROM users 
        LEFT JOIN parselet_versions ON parselet_versions.user_id = users.id WHERE parselet_versions.works=1 GROUP BY parselet_versions.user_id ORDER BY p DESC LIMIT #{n.to_i}"
    end

    def find_by_api_key(key)
      login, pwd = key.split("-")
      u = find_by_login(login)
      u && u.crypted_password[0..8] && u
    end
    
    def find_by_key(key)
      find_by_login(key)
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
  
  validates_format_of :login, :with => /[^0-9]/, :message => "cannot be entirely numeric"
  
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
