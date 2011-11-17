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

role :app, domain
role :web, domain
role :db, domain, :primary => true

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
