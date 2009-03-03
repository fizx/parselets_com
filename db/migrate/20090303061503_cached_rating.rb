class CachedRating < ActiveRecord::Migration
  def self.up
    add_column :parselets, :cached_rating, :integer, :null => false
    add_column :parselet_versions, :cached_rating, :integer, :null => false
  end

  def self.down
    remove_column :parselets, :cached_rating
    remove_column :parselet_versions, :cached_rating
  end
end
