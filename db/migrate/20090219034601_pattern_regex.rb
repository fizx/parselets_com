class PatternRegex < ActiveRecord::Migration
  def self.up
    remove_column :parselets, :pattern_regex
  end

  def self.down
    add_column :parselets, :pattern_regex, :boolean
  end
end
