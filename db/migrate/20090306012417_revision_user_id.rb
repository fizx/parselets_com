class RevisionUserId < ActiveRecord::Migration
  def self.up
    add_column :parselets, :revision_user_id, :integer
    # add_column :parselet_versions, :revision_user_id, :integer
  end

  def self.down
    remove_column :parselets, :revision_user_id
  end
end
