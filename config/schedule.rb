# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :cron_log, "/var/www/parselets/shared/log/whenever.log"

every 1.day, :at => "12 am" do
  rake "parselet:check"
  rake "ultrasphinx:index"
end

every 1.minute do
  rake "parselet:check"
end

every 1.minute do
  rake "ultrasphinx:index:delta"
end

every 1.hour do
  rake "update_karma"
end