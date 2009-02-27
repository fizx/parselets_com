require "sprig/version"
class Sprig < ActiveRecord::Base
  module ClassMethods
    def top(n = 5)
      find :all, :limit => n
    end    
  end
  extend ClassMethods
  
  belongs_to :user
  
  acts_as_versioned
  acts_as_paranoid
  
  is_indexed :fields => ["name", "description"],
    :include => [
      {:association_name => 'user', :field => 'login'}
    ],
    :conditions => "sprigs.deleted_at IS NULL AND user_id IS NOT NULL",
    :order => "sprigs.updated_at DESC", :delta => true
  
end
