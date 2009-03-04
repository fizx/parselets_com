class EnforceDefaults < ActiveRecord::Migration
  def self.up
    change_column :parselets, :ratings_count, :integer, :null => false, :default => 0
    change_column :parselet_versions, :ratings_count, :integer, :null => false, :default => 0
    change_column :parselets, :comments_count, :integer, :null => false, :default => 0
    change_column :parselet_versions, :comments_count, :integer, :null => false, :default => 0
    change_column :parselets, :cached_rating, :integer, :null => false, :default => 0
    change_column :parselet_versions, :cached_rating, :integer, :null => false, :default => 0
  end

  def self.down
  end
end
