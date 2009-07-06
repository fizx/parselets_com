class UpgradeToNewVersionSystem < ActiveRecord::Migration
  class ParseletVersion < ActiveRecord::Base; end

  def self.up
    Parselet.connection.execute("DELETE FROM parselets WHERE deleted_at is not null")
    remove_column(:parselets, :cached_changes) if Parselet.columns.any? {|i| i.name == 'cached_changes' }
    remove_column(:parselets, :deleted_at) if Parselet.columns.any? {|i| i.name == 'deleted_at' }

    remove_index :parselets, :name
    remove_index :sprigs, :name
    add_index "parselets", ["name"], :name => "index_parselets_on_name"
    add_index "sprigs", ["name"], :name => "index_sprigs_on_name"
    
    change_column_default(:parselets, :version, 1)
    change_column_default(:parselets, :works, 0)
    
    Parselet.reset_column_information
    
    # Parselet.transaction do      
    #   versions = ParseletVersion.find(:all, :order => 'parselet_id, version ASC')
    #   parselets = Parselet.find(:all, :order => 'id')
    #   
    #   assets = {}
    #   parselets.each do |parselet|
    #     assets[parselet.id] = { :ratings => parselet.ratings, :comments => parselet.comments, :favorites => parselet.favorites }
    #   end
    #   
    #   Parselet.delete_all
    # 
    #   seen_name = {}
    #   
    #   versions.each do |version|
    #     attributes = version.attributes
    #     old_id = version.parselet_id
    #     parselet = Parselet.new
    #     (attributes.keys - ["parselet_id", "pattern_regex", "id", "cached_rating", "comments_count", 
    #                         "ratings_count", "revision_user_id", "user_id"]).each do |key|
    #       parselet[key] = attributes[key]
    #     end
    #     parselet.user_id = version.revision_user_id || version.user_id
    #     puts "Saving #{parselet.name}:#{parselet.version}..."
    #     Parselet.ignoring_callbacks do
    #       unless parselet.save(false)
    #         raise Exception.new("Save error on: #{attributes.inspect}")
    #       end
    #       if !seen_name[version.name]
    #         puts "Assigning assets"
    #         seen_name[version.name] = true
    #         assets[old_id][:comments].each { |comment| parselet.comments << comment }
    #         assets[old_id][:ratings].each { |rating| parselet.ratings << rating }
    #         assets[old_id][:favorites].each { |favorite| parselet.favorites << favorite }
    #       
    #         parselet.comments_count = parselet.comments.count
    #         parselet.ratings_count = parselet.ratings.count
    #       
    #         unless parselet.save(false)
    #           raise Exception.new("Save error on: #{attributes.inspect}")
    #         end
    #       
    #         parselet.ratings.first.update_target if parselet.ratings.first
    #       end
    #     end
    #   end
    # end
    
    # drop_table :parselet_versions
    remove_column(:parselets, :revision_user_id)
  end

  def self.down
    add_column :parselets, :cached_changes, :text
    add_column :parselets, :deleted_at, :datetime
    add_column :parselets, :revision_user_id, :integer
    drop_index :parselets, :name
    drop_index :sprigs, :name
    add_index "parselets", ["name"], :name => "index_parselets_on_name", :unique => true
    add_index "sprigs", ["name"], :name => "index_sprigs_on_name", :unique => true
  end
end
