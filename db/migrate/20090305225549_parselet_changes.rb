class ParseletChanges < ActiveRecord::Migration
  def self.up
    add_column :parselets, :cached_changes, :text
    # add_column :parselet_versions, :cached_changes, :text
    Parselet.each do |p|
      p.calculate_changes
      p.save
    end
    # Parselet::Version.each do |p|
    #   p.calculate_changes
    #   p.save
    # end
  end

  def self.down
    remove_column :parselets, :cached_changes
    remove_column(:parselet_versions, :cached_changes) if ActiveRecord::Base.connection.tables.include?('parselet_versions')
  end
end
