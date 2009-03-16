namespace :parselet do
  desc "Check all parselets"
  task :check do
    require "config/environment"
    Parselet.each do |i|
      begin
        i.check
      rescue Exception => e
        puts "On Parselet #{i.id}:"
        puts e.message
        puts e.backtrace
      end
    end
    Parselet::Version.each do |i|
      begin
        i.check
      rescue Exception => e
        puts "On Parselet::Version #{i.id}:"
        puts e.message
        puts e.backtrace
      end
    end
  end
  
  task :changes do
    require "config/environment"
    Parselet::Version.each &:save
  end
end

