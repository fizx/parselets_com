class AddBestVersionToParselets < ActiveRecord::Migration
  def self.up
    add_column :parselets, :best_version, :boolean, :default => false
    add_column :parselets, :score, :float, :default => 0.0
    
    Parselet.reset_column_information

    Parselet.each do |i|
      begin
        i.check
      rescue Exception => e
        puts "On Parselet #{i.id}:"
        puts e.message
        puts e.backtrace
      end
    end

    Parselet.transaction do
      Parselet.find(:all).each do |parselet|
        parselet.update_score_and_best_version
      end
    end
  end

  def self.down
    remove_column :parselets, :best_version
    remove_column :parselets, :score
  end
end
