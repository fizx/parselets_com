namespace :parselet do
  desc "Check all parselets"
  task :check do
    require "config/environment"
    Parselet.find(:all).each do |i|
      begin
        i.check
      rescue Exception => e
        puts "On Parselet #{i.id}:"
        puts e.message
        puts e.backtrace
      end
    end
  end

  desc "Force check on all parselets"
  task :force_check do
    require "config/environment"
    Parselet.find(:all).each do |i|
      begin
        i.check!
      rescue Exception => e
        puts "On Parselet #{i.id}:"
        puts e.message
        puts e.backtrace
      end
    end
  end

  
  desc "Recalculate all parselet scores and best versions"
  task :score do
    require "config/environment"
    Parselet.find(:all).each do |parselet|
      parselet.update_score_and_best_version
    end
  end
end

