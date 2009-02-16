class Versions < ActiveRecord::Migration
  def self.up
    Parselet.create_versioned_table
    Sprig.create_versioned_table
  end

  def self.down
    Parselet.drop_versioned_table
    Sprig.drop_versioned_table
  end
end
