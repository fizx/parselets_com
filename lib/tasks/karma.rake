task :update_karma do
  require "config/environment"
  User.each do |u|
    u.recalculate_base_karma
    u.save
    STDOUT.print "."
    STDOUT.flush
  end
end