class ThumbnailTries < ActiveRecord::Migration
  def self.up
    add_column :thumbnails, :tries, :integer
  end

  def self.down
    remove_column :thumbnails, :tries, :integer
  end
end
