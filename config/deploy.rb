ssh_options[:forward_agent] = true

require 'json'
set :user_details, JSON.parse(IO.read('dna.json'))

set :domain, "capdemo.bangline.co.uk"

set :application, domain
set :user, user_details['name']
set :password, user_details['password']
set :deploy_to, "/home/#{user}"
set :use_sudo, false
set :gemset, "capdemo"

set :repository, "git@github.com:bangline/capdemo.git"
set :scm, :git
set :branch, "master"

role :app, domain
role :web, domain
role :db, domain, :primary => true

require "bundler/capistrano"

$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) 
require "rvm/capistrano"           
set :rvm_ruby_string, "1.9.2@#{gemset}" 

namespace :deploy do
  task :start do ; end

  task :stop do ; end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end

  task :create_gemset do
    run "rvm use 1.9.2@#{gemset} --create"
  end
end

after "deploy", "rvm:trust_rvmrc"
