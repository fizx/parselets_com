class RatingsCount < ActiveRecord::Migration
  def self.up
    add_column :parselets, :ratings_count, :integer, :null => false, :default => 0
    # add_column :parselet_versions, :ratings_count, :integer, :null => false, :default => 0
    add_column :parselets, :comments_count, :integer, :null => false, :default => 0
    # add_column :parselet_versions, :comments_count, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :parselets, :ratings_count
    remove_column(:parselet_versions, :ratings_count) if ActiveRecord::Base.connection.tables.include?('parselet_versions')
    remove_column :parselets, :comments_count
    remove_column(:parselet_versions, :comments_count) if ActiveRecord::Base.connection.tables.include?('parselet_versions')
  end
end
