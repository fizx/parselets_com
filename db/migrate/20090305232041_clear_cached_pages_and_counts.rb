class ClearCachedPagesAndCounts < ActiveRecord::Migration
  def self.up
    CachedPage.find(:all).each {|i| i.destroy }
    [Parselet::Version, Parselet].each do |model|
      model.find(:all).each {|i| i.cached_page = nil; i.save! }
    end
  end

  def self.down
  end
end
