class ParseletCachedPage < ActiveRecord::Migration
  def self.up
    add_column :parselets, :cached_page_id, :integer
    # add_column :parselet_versions, :cached_page_id, :integer
  end

  def self.down
    remove_column :parselets, :cached_page_id
    remove_column(:parselet_versions, :cached_page_id) if ActiveRecord::Base.connection.tables.include?('parselet_versions')
  end
end
