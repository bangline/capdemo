ssh_options[:forward_agent] = true

require 'json'
set :user_details, JSON.parse(IO.read('dna.json'))

set :domain, "capdemo.bangline.co.uk"

set :application, domain
set :user, user_details['name']
set :password, user_details['password']
set :deploy_to, "/home/#{user}"
set :use_sudo, false

set :repository, "git@github.com:bangline/capdemo.git"
set :scm, :git
set :branch, "master"

set :deploy_via, :remote_cache

role :app, domain
role :web, domain
role :db, domain, :primary => true

require "bundler/capistrano"

namespace :deploy do
  task :start do ; end

  task :stop do ; end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :log_deploy do
    date = DateTime.now
    run "cd #{shared_path}; touch REVISION_HISTORY"
    run "cd #{shared_path};( echo '#{date.strftime("%m/%d/%Y - %I:%M%p")} : Vesrion #{latest_revision[0..6]} was deployed.' ; cat REVISION_HISTORY) > rev_tmp && mv rev_tmp REVISION_HISTORY"
  end

  task :history do
    run "tail #{shared_path}/REVISION_HISTORY" do | ch, stream, out |
      puts out
    end
  end
end

namespace :assets do
  task :compile, :roles => :web, :except => { :no_release => true } do
    run "cd #{current_path}; rm -rf public/assets/*"
    run "cd #{current_path}; bundle exec rake assets:precompile RAILS_ENV=production"
  end
end
after "deploy", "deploy:log_deploy"
before "deploy:restart", "assets:compile"
