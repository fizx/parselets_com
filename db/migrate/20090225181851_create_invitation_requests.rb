class CreateInvitationRequests < ActiveRecord::Migration
  def self.up
    create_table :invitation_requests do |t|
      t.integer :invitation_id
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :invitation_requests
  end
end
