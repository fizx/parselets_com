namespace :db do 
  
  MYSQLDUMP_FILE = "db/dump.sql"
  
  def mysql_config
    require "config/environment"
    require "ostruct"
    yaml = YAML::load(File.read("config/database.yml"))
    cfg = OpenStruct.new(yaml[RAILS_ENV])
    str =  " -u #{cfg.username} #{cfg.database}"
    str += " --password='#{cfg.password}'"       if cfg.password
    str += " -h #{cfg.host}"                     if cfg.host
    str
  end
  
  desc "dumps the current db to #{MYSQLDUMP_FILE}"
  task :dump do
    cmd = "mysqldump #{mysql_config} > #{MYSQLDUMP_FILE}"
    puts cmd
    system cmd
  end
  
  desc "loads the current db from #{MYSQLDUMP_FILE}"
  task :load do
    if File.exists?(MYSQLDUMP_FILE)
      cmd = "cat #{MYSQLDUMP_FILE} | mysql #{mysql_config} "
      puts cmd
      system cmd
    end
  end
end