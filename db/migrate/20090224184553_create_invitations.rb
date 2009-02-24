class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.string :code
      t.integer :user_id
      t.integer :usages

      t.timestamps
    end
    
    add_column :users, :invitation_id, :integer
  end

  def self.down
    remove_column :users, :invitation_id
    
    drop_table :invitations
  end
end
