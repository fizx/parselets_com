class CachedRating < ActiveRecord::Migration
  def self.up
    add_column :parselets, :cached_rating, :integer, :null => false, :default => 0
    add_column :parselet_versions, :cached_rating, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :parselets, :cached_rating
    remove_column :parselet_versions, :cached_rating
  end
end
