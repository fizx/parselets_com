class MatchGroups < ActiveRecord::Migration
  def self.up
    add_column :parselets, :match_groups, :string
  end

  def self.down
    remove_column :parselets, :match_groups
  end
end
