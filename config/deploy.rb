set :application, "parselets"
set :repository,  "git@github.com:fizx/parselets_com.git"
set :deploy_to, "/var/www/#{application}"
set :scm, :git
set :branch, "master"
set :user, "www-data"
set :use_sudo, false
set :deploy_via, :remote_cache

SERVER = "parselets.org"

role :app, SERVER
role :web, SERVER
role :db,  SERVER, :primary => true

namespace :deploy do
  task :before_restart do
    run "ln -nfs #{shared_path}/thumbs #{current_path}/public/thumbs"
    run "cd #{current_path} && rake db:migrate --trace RAILS_ENV=production"
    run "cd #{current_path} && rake us:boot --trace RAILS_ENV=production"
  end
  
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  task :after_restart do
    system %[echo "deploy complete" | growlnotify "parselets.com"]
  end
  
  desc "write the crontab file"
  task :write_crontab, :roles => :app do
    run "cd #{release_path} && whenever --write-crontab -n #{application}"
  end
end

after "deploy:symlink", "deploy:write_crontab"

task :delta do
  run "cd #{current_path} && rake ultrasphinx:index:delta --trace RAILS_ENV=production"
end

task :reindex do
  run "cd #{current_path} && rake us:boot --trace RAILS_ENV=production"
end

task :update_karma do
  run "cd #{current_path} && rake update_karma RAILS_ENV=production"
end

task :check do
  run "cd #{current_path} && rake parselet:check --trace RAILS_ENV=production"
end

task :tail do
  run "tail -f #{current_path}/log/production.log"
end

task :tail_cron do
  run "tail -f #{current_path}/log/whenever.log"
end