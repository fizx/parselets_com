class ClearCachedPagesAndCounts < ActiveRecord::Migration
  def self.up
    CachedPage.delete_all
    Parselet.each do |p|
      p.cached_page = nil
      p.save_without_revision
    end
    
    Parselet::Version.each do |p|
      p.cached_page = nil
      p.save
    end
  end

  def self.down
  end
end
