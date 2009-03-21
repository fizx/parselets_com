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
  end
end

