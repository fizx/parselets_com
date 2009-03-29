class AddAllowUserContactToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :allow_user_contact, :boolean, :default => true
  end

  def self.down
    remove_column :users, :allow_user_contact
  end
end
