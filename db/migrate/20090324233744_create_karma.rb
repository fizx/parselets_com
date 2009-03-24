class CreateKarma < ActiveRecord::Migration
  def self.up
    create_table :karma do |t|
      t.integer :user_id
      t.integer :value
      t.string :description

      t.timestamps
    end
    
    add_column :users, :base_karma, :integer
  end

  def self.down
    remove_column :users, :base_karma
    drop_table :karma
  end
end
