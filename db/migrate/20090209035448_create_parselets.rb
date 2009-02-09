class CreateParselets < ActiveRecord::Migration
  def self.up
    create_table :parselets do |t|
      t.string :name
      t.text :description
      t.text :code
      t.string :pattern
      t.string :example_url
      t.string :domain_id
      t.integer :user_id
      t.integer :version
      t.boolean :pattern_regex
      t.datetime :deleted_at

      t.timestamps
    end
  end

  def self.down
    drop_table :parselets
  end
end
