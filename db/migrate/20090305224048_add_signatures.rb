class AddSignatures < ActiveRecord::Migration
  def self.up
    add_column :parselets, :signature, :text
    # add_column :parselet_versions, :signature, :text
    Parselet.each{|p|
      p.calculate_signature
      p.save!
    }
    
    # Parselet::Version.each{|p|
    #   p.calculate_signature
    # }
  end

  def self.down
  end
end
