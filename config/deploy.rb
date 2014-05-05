require 'rvm/capistrano'
require 'bundler/capistrano'
require 'yaml'

APP_CONFIG = YAML.load_file("#{Rails.root}/config/webserver.yml")[Rails.env]


set :application, "Greenfootball"
set :repository,  "git@github.com:swytman/greenfootball.git"
set :deploy_to, "/home/swytman/greenfootball"
set :scm, :git
set :branch, "master"
set :user, APP_CONFIG['production']['user']
set :password, APP_CONFIG['production']['password']
set :use_sudo, false
set :rails_env, "production"
set :deploy_via, :copy
set :ssh_options, { :port => 17768 }
set :keep_releases, 10
default_run_options[:pty] = true
server "swyttalk.ru", :app, :web, :db, :primary => true

set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/current/shared/pids/unicorn.pid"

after 'deploy:update_code', 'deploy:symlink_shared'
after 'deploy:symlink_shared', 'db:migrate'
after 'deploy:restart', 'unicorn:restart'

def run_remote_rake(rake_cmd)
  rake_args = ENV['RAKE_ARGS'].to_s.split(',')
  cmd = "cd #{fetch(:latest_release)} && #{fetch(:rake, "rake")} RAILS_ENV=#{fetch(:rails_env, "production")} #{rake_cmd}"
  cmd += "['#{rake_args.join("','")}']" unless rake_args.empty?
  run cmd
  set :rakefile, nil if exists?(:rakefile)
end

#DEPLOY
namespace :deploy do
  desc "Restart Resque Workers"
  task :restart_workers, :roles => :db do
    run_remote_rake "resque:restart_workers"
  end

  desc "Restart Resque scheduler"
  task :restart_scheduler, :roles => :db do
    run_remote_rake "resque:restart_scheduler"
  end

  desc "Symlinks"
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

end


# UNICORN
namespace :unicorn do
  task :restart do
    stop
    start
  end
  task :start do
    run "cd #{current_path}; bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D"
  end
  task :stop do
    run "kill -QUIT `ps -ef | grep unicorn | grep -v grep | awk '{print $2}'`"
  end
end

#NGINX
namespace :nginx do
  task :restart do
    sudo "sudo service nginx restart"
  end
  task :start do
    sudo "sudo service nginx start"
  end
  task :stop do
    sudo "sudo service nginx stop"
  end

end

# DB
namespace :db do
  task :migrate do
    run_remote_rake "db:migrate"
  end
end