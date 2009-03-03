class RatingsCount < ActiveRecord::Migration
  def self.up
    add_column :parselets, :ratings_count, :integer, :null => false
    add_column :parselet_versions, :ratings_count, :integer, :null => false
    add_column :parselets, :comments_count, :integer, :null => false
    add_column :parselet_versions, :comments_count, :integer, :null => false
  end

  def self.down
    remove_column :parselets, :ratings_count
    remove_column :parselet_versions, :ratings_count
    remove_column :parselets, :comments_count
    remove_column :parselet_versions, :comments_count
  end
end
