class CreateThumbnails < ActiveRecord::Migration
  def self.up
    create_table :thumbnails do |t|
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :thumbnails
  end
end
