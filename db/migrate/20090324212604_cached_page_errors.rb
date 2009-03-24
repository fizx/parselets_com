class CachedPageErrors < ActiveRecord::Migration
  def self.up
    add_column :cached_pages, :error_message, :text
  end

  def self.down
    remove_column :cached_pages, :error_message
  end
end
