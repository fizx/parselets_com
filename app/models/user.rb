require File.dirname(__FILE__) + '/user/auth'
require "digest"

class User < ActiveRecord::Base
  has_many :sprigs
  has_many :parselets, :group => 'name'
  has_many :favorites, :order => "created_at DESC"
  
  is_indexed :fields => %w[login name], :delta => true
  
  before_save :update_karma
  
  validates_format_of :login, :with => /[^0-9]/, :message => "cannot be entirely numeric"
  
  before_save :set_api_key
  
  def update_karma
    self.cached_karma = total_karma
  rescue
    #ignore me
  end
  
  def total_karma
    base_karma + Karma.sum("value", :conditions => {:user_id => id}) + 1
  end
  
  def recalculate_base_karma
    self.base_karma = parselets.count
  end
  
  def parselet_count
    Parselet.count(:conditions => ['user_id = ?', id], :group => 'name').length
  end
  
  def reset_key
    "#{login}-#{Digest::MD5.hexdigest(crypted_password[0..8])}"
  end
  
  def to_param
    login
  end
  
  def key
    self[:login]
  end

  def set_api_key
    self.api_key = "#{login}-#{Digest::MD5.hexdigest((rand * 10000).to_s)[0..8]}" if api_key.blank?
  end
  
  def reset_api_key
    self.api_key = nil
    self.save
  end
  
  # CLASS METHODS

  def self.top(n = 5)
    find_by_sql "SELECT users.*, COUNT(parselets.id) as p FROM users 
      LEFT JOIN parselets ON parselets.user_id = users.id WHERE parselets.works=1 GROUP BY parselets.user_id ORDER BY p DESC LIMIT #{n.to_i}"
  end

  def self.find_by_reset_key(key)
    login, pwd = key.split("-")
    u = find_by_login(login)
    u && Digest::MD5.hexdigest(u.crypted_password[0..8]) == pwd && u
  end

  def self.find_by_key(key)
    find_by_login(key)
  end
  
  def self.find_by_params(params)
    id = params[:user] || params[:user_id] || params[:id]
    if id =~ /\A\d+\Z/
      find_by_id(id)
    else
      find_by_login(id)
    end
  end
end
