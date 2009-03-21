class Versions < ActiveRecord::Migration
  def self.up
    # Parselet.create_versioned_table
    # Sprig.create_versioned_table
  end

  def self.down
    drop_table(:parselet_versions) if ActiveRecord::Base.connection.tables.include?('parselet_versions')
    drop_table(:sprig_versions) ActiveRecord::Base.connection.tables.include?('sprig_versions')
  end
end
