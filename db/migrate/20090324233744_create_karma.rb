class CreateKarma < ActiveRecord::Migration
  def self.up
    create_table :karmas do |t|
      t.integer :user_id
      t.integer :value
      t.string :description

      t.timestamps
    end
    
    add_column :users, :base_karma, :integer, :default => 0
    add_column :users, :cached_karma, :integer, :default => 0
  end

  def self.down
    remove_column :users, :base_karma
    remove_column :users, :cached_karma
    drop_table :karmas
  end
end
