class ResetRatingCounts < ActiveRecord::Migration
  def self.up
    [Parselet].each do |model|
      model.find(:all).each do |instance|
        model.update_counters instance.id, :ratings_count => (-1 * instance.ratings_count + instance.ratings.count)
      end
    end
  end

  def self.down
  end
end
