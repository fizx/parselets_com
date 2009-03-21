class WorkedAtRevamp < ActiveRecord::Migration
  def self.up
    rename_column :parselets, :worked_at, :checked_at
    # rename_column :parselet_versions, :worked_at, :checked_at
    add_column :parselets, :works, :boolean
    # add_column :parselet_versions, :works, :boolean
  end

  def self.down
    rename_column :parselets, :checked_at, :worked_at
    rename_column(:parselet_versions, :checked_at, :worked_at) if ActiveRecord::Base.connection.tables.include?('parselet_versions')
    remove_column :parselets, :works
    remove_column(:parselet_versions, :works) if ActiveRecord::Base.connection.tables.include?('parselet_versions')
  end
end
