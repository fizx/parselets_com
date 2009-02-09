class CreateSprigs < ActiveRecord::Migration
  def self.up
    create_table :sprigs do |t|
      t.string :name
      t.text :description
      t.text :code
      t.integer :user_id
      t.integer :version
      t.datetime :deleted_at

      t.timestamps
    end
  end

  def self.down
    drop_table :sprigs
  end
end
