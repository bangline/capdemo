require 'json'

user = JSON.parse('../dna.json')

ssh_options[:forward_agent] = true

set :application, "capistrano_demo"
set :user, user['name']
set :password, user['password']
set :deploy_to, "/home/#{user}/app"

set :repository, "git@github.com:bangline/icapistrano_demo.git"
set :scm, :git
set :branch, "master"

role :app, "capdemo.bangline.co.uk"
role :web, "capdemo.bangline.co.uk"
role :db, "capdemo.bangline.co.uk", :primary => true

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
