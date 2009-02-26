namespace :parselet do
  task :check do
    require "config/environment"
    Parselet.each &:check
  end
end

