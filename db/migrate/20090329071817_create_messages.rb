class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.text :text, :null => false
      t.integer :from_user_id, :null => false
      t.integer :to_user_id, :null => false
      t.text :subject, :null => false
      t.datetime :deleted, :default => nil

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
