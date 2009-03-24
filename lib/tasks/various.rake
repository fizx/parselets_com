namespace :various do
  desc "Update Rdoc for online_parselets gem"
  task :update_online_parselets_rdoc do
    require "config/environment"
    system "mkdir -p #{RAILS_ROOT}/public/dev"
    system "cd #{RAILS_ROOT}/public/dev && git clone git://github.com/iterationlabs/online_parselets.git tmp_checkout"
    system "cd #{RAILS_ROOT}/public/dev/tmp_checkout && rdoc --force README lib"
    system "cd #{RAILS_ROOT}/public/dev && mv tmp_checkout/doc ./tmp_rdoc"
    system "cd #{RAILS_ROOT}/public/dev && rm -rf online_parselets tmp_checkout"
    system "cd #{RAILS_ROOT}/public/dev && mv tmp_rdoc online_parselets"
  end
end
