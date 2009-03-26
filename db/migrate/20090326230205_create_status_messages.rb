class CreateStatusMessages < ActiveRecord::Migration
  def self.up
    create_table :status_messages do |t|
      t.text :message
      t.integer :user_id
      t.boolean :active

      t.timestamps
    end
  end

  def self.down
    drop_table :status_messages
  end
end
