class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :score
      t.integer :ratable_id
      t.string :ratable_type

      t.timestamps
    end
  end

  def self.down
    drop_table :ratings
  end
end
