class CreatePasswordRequests < ActiveRecord::Migration
  def self.up
    create_table :password_requests do |t|
      t.string :email
      t.datetime :sent_at

      t.timestamps
    end
  end

  def self.down
    drop_table :password_requests
  end
end
