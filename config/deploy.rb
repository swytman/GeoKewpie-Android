#require 'rvm/capistrano'
#require 'bundler/capistrano'

set :application, "Greenfootball"
set :repo_url,  "git@github.com:swytman/greenfootball.git"
set :deploy_to, "/home/swytman/greenfootball"

set :scm, :git
set :branch, "master"

#set :use_sudo, false

set :deploy_via, :copy

set :keep_releases, 10
set :pty, true

set :ssh_options, :forward_agent => true

set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/current/shared/pids/unicorn.pid"



#def run_remote_rake(rake_cmd)
#  rake_args = ENV['RAKE_ARGS'].to_s.split(',')
#  cmd = "cd #{fetch(:latest_release)} && #{fetch(:rake, "rake")} RAILS_ENV=#{fetch(:rails_env, "production")} #{rake_cmd}"
#  cmd += "['#{rake_args.join("','")}']" unless rake_args.empty?
#  on roles(:app) do
#   cmd
#  end
#  set :rakefile, nil if exists?(:rakefile)
#end

#DEPLOY
namespace :deploy do
  #desc "Restart Resque Workers"
  #task :restart_workers, :roles => :db do
  #  run_remote_rake "resque:restart_workers"
  #end
  #
  #desc "Restart Resque scheduler"
  #task :restart_scheduler, :roles => :db do
  #  run_remote_rake "resque:restart_scheduler"
  #end

  desc "Symlinks"
  task :symlink_shared do
    on roles(:app) do
      execute "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
      execute "ln -nfs #{shared_path}/config/webserver.yml #{release_path}/config/webserver.yml"
    end
  end

end


# UNICORN
namespace :unicorn do
  task :restart do
    stop
    start
  end
  task :start do
    on roles(:app) do
      execute "cd #{current_path}; bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D"
    end
  end
  task :stop do
    on roles(:app) do
      execute "kill -QUIT `ps -ef | grep unicorn | grep -v grep | awk '{print $2}'`"
    end
  end
end

#NGINX
namespace :nginx do
  task :restart do
    on roles(:web) do
      execute "sudo service nginx restart"
    end
  end
  task :start do
    on roles(:web) do
      execute "sudo service nginx start"
    end
  end
  task :stop do
    on roles(:web) do
      execute "sudo service nginx stop"
    end
  end

end

# DB
namespace :db do
  task :migrate do
    on roles(:db) do
      execute "rake db:migrate"
    end
  end
end

after 'deploy:updated', 'deploy:symlink_shared'
after 'deploy:symlink_shared', 'db:migrate'
after 'deploy:finished', 'unicorn:restart'