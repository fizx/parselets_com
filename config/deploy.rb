set :application, "parselets"
set :repository,  "git@github.com:fizx/parselets_com.git"
set :deploy_to, "/var/www/#{application}"
set :scm, :git
set :branch, "master"
set :user, "www-data"
set :use_sudo, false

SERVER = "parselets.org"

role :app, SERVER
role :web, SERVER
role :db,  SERVER, :primary => true

namespace :deploy do
  task :before_restart do
    run "cd #{current_path} && rake db:migrate --trace RAILS_ENV=production"
    run "cd #{current_path} && rake us:boot --trace RAILS_ENV=production"
  end
  
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  task :after_restart do
    system %[echo "deploy complete" | growlnotify "parselets.com"]
  end
end