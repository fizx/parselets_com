class CreateSprigUsages < ActiveRecord::Migration
  def self.up
    create_table :sprig_usages do |t|
      t.integer :sprig_id
      t.integer :sprig_version_id
      t.integer :parselet_id
      t.integer :parselet_version_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sprig_usages
  end
end
