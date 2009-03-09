class ParseletVersionsCreated < ActiveRecord::Migration
  def self.up
    add_column :parselet_versions, :created_at, :datetime
    Parselet::Version.update_all "created_at=NOW()"
  end

  def self.down
    remove_column :parselet_versions, :created_at
  end
end
