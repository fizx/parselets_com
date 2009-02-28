namespace :db do 
  
  MYSQLDUMP_FILE = "db/dump.sql"
  
  def sys(cmd)
    puts cmd
    system cmd
  end
  
  def mysql_config(env = RAILS_ENV)
    require "config/environment"
    require "ostruct"
    yaml = YAML::load(File.read("config/database.yml"))
    cfg = OpenStruct.new(yaml[env])
    str =  " -u #{cfg.username} #{cfg.database}"
    str += " --password='#{cfg.password}'"       if cfg.password
    str += " -h #{cfg.host}"                     if cfg.host
    str
  end
  
  desc "dumps the current db to #{MYSQLDUMP_FILE}"
  task :dump do
    sys "mysqldump #{mysql_config} > #{MYSQLDUMP_FILE}"
  end
  
  desc "loads the current db from #{MYSQLDUMP_FILE}"
  task :load do
    if File.exists?(MYSQLDUMP_FILE)
      sys "cat #{MYSQLDUMP_FILE} | mysql #{mysql_config} "
    end
  end
  
  task :"load-production" do
    sys "ssh parselets.com 'mysqldump #{mysql_config('production')} > ~/dump.sql'"
    sys "rsync -avz --partial --progress parselets.com:dump.sql #{MYSQLDUMP_FILE}"
    sys "cat #{MYSQLDUMP_FILE} | mysql #{mysql_config} "
  end
end