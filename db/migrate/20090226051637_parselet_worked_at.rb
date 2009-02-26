class ParseletWorkedAt < ActiveRecord::Migration
  def self.up
    add_column :parselets, :worked_at, :datetime
    add_column :parselet_versions, :worked_at, :datetime
  end

  def self.down
    remove_column :parselets, :worked_at
    remove_column :parselet_versions, :worked_at
  end
end
