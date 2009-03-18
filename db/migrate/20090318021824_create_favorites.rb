class CreateFavorites < ActiveRecord::Migration
  def self.up
    create_table :favorites do |t|
      t.integer :user_id, :null => false
      t.integer :favoritable_id, :null => false
      t.string :favoritable_type, :null => false

      t.timestamps
    end
    add_index :favorites, :user_id
    add_index :favorites, :favoritable_id
  end

  def self.down
    drop_table :favorites
  end
end
