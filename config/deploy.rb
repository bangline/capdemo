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

  task :compile_assets, :roles => :web, :except => { :no_release => true } do
    run "cd #{current_path}; rm -rf public/assets/*"
    run "cd #{current_path}; bundle exec rake assets:precompile RAILS_ENV=production"
  end
end

before "deploy:restart", "deploy:compile_assets"
