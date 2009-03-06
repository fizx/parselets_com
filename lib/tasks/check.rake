namespace :parselet do
  task :check do
    require "config/environment"
    Parselet.each &:check
    Parselet::Version.each &:check
  end
  
  task :changes do
    require "config/environment"
    Parselet::Version.each &:save
  end
end

