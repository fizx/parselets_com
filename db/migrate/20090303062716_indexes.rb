class Indexes < ActiveRecord::Migration
  def self.up
    Parselet.connection.execute("DELETE FROM parselets WHERE deleted_at is not null")
    add_index :cached_pages, :url
    
    add_index :comments, :user_id
    add_index :comments, [:commentable_id, :commentable_type, :created_at], :name => "commentable_poly" 
    
    # add_index :domain_usages, [:domain_id, :usage_id, :usage_type], :unique => true, :name => "domain_usages_ids"
    
    add_index :domains, :name, :unique => true
    
    add_index :invitation_requests, :email
    add_index :invitation_requests, :invitation_id
    
    add_index :invitations, :code, :unique => true
    add_index :invitations, :user_id
    
    # add_index :parselet_versions, [:parselet_id, :version], :unique => true
    # add_index :parselet_versions, :name
    # add_index :parselet_versions, :domain_id
    # add_index :parselet_versions, :user_id
    # add_index :parselet_versions, :cached_page_id

    add_index :parselets, :name, :unique => true
    add_index :parselets, :domain_id
    add_index :parselets, :user_id
    add_index :parselets, :cached_page_id
    
    add_index :password_requests, :email
    
    
    add_index :ratings, :user_id
    add_index :ratings, [:ratable_id, :ratable_type]
    
    add_index :sprig_usages, [:sprig_id, :parselet_id], :unique => true, :name => "sprig_usages_ids"
    
    # add_index :sprig_versions, [:sprig_id, :version], :unique => true
    # add_index :sprig_versions, :name
    # add_index :sprig_versions, :user_id
    
    add_index :sprigs, :name, :unique => true
    add_index :sprigs, :user_id
    
    add_index :thumbnails, :url, :unique => true
    
    add_index :users, :email, :unique => true
    
  end

  def self.down
  end
end
