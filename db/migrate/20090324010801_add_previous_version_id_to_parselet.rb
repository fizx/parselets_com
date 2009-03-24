class AddPreviousVersionIdToParselet < ActiveRecord::Migration
  def self.up
    add_column :parselets, :previous_version_id, :integer
    
    # Infer previous versions
    Parselet.reset_column_information
    Parselet.ignoring_callbacks do
      Parselet.find(:all).each do |parselet|
        next if parselet.previous_version_id
        parselet.previous_version = Parselet.find_by_name_and_version(parselet.name, parselet.version - 1)
        puts "Updated #{parselet.name} v#{parselet.version} to have a previous_version of #{parselet.previous_version.try(:name)} v#{parselet.previous_version.try(:version)}."
        parselet.save(false)
      end
    end
  end

  def self.down
    remove_column :parselets, :previous_version_id
  end
end
