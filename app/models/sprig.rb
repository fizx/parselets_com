class Sprig < ActiveRecord::Base
  module ClassMethods
    def top(n = 5)
      find :all, :limit => n
    end    
  end
  extend ClassMethods
  
  belongs_to :user
  has_many :comments, :as => :commentable
  
  is_indexed :fields => ["name", "description"],
    :include => [
      {:association_name => 'user', :field => 'login'}
    ],
    :conditions => "user_id IS NOT NULL",
    :order => "sprigs.updated_at DESC", :delta => true
  
  validates_presence_of :name, :scope => :version
  validates_presence_of :description, :code
  validates_format_of :name, :with => /\A[a-z0-9\-_]*\Z/, :message => "contains invalid characters"
  
  def keys=(a)
    self.code = a.inspect
  end
  
  def keys
    eval(code || "[]").map{|a| a unless a.blank? }.compact
  end
end
