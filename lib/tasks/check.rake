namespace :parselet do
  task :check do
    require "config/environment"
    Parselet.each &:check
    Parselet::Version.each &:check
  end
end

