
set :application, 'greenfootball.ru'
set :repo_url, 'https://github.com/swytman/greenfootball.git'
set :deploy_to, '/var/www/greenfootball'
set :current_path,  "#{fetch(:deploy_to)}/current"
set :unicorn_conf, "#{fetch(:deploy_to)}/current/config/unicorn/#{fetch(:stage)}.rb"
set :unicorn_pid, "#{fetch(:deploy_to)}/shared/pids/unicorn.pid"
set :linked_files, %w{config/database.yml}

# UNICORN
namespace :unicorn do

  task :restart do
    on roles :all do
      #execute "if [ -f #{fetch(:unicorn_pid)} ]; then disown `cat #{fetch(:unicorn_pid)} && kill -QUIT `cat #{fetch(:unicorn_pid)}`; fi"
      execute "if [ -f #{fetch(:unicorn_pid)} ]; then kill -13 `cat #{fetch(:unicorn_pid)}`; else cd #{fetch(:current_path)} && bundle exec unicorn -c #{fetch(:unicorn_conf)} -E #{fetch(:stage)} -D; fi"
    end
  end

  task :start do
    on roles :all do
      execute "cd #{fetch(:current_path)} && bundle exec unicorn -c #{fetch(:unicorn_conf)} -E #{fetch(:stage)} -D"
    end
  end

  task :stop do
    on roles :all do
      execute "if [ -f #{fetch(:unicorn_pid)} ]; then kill -QUIT `cat #{fetch(:unicorn_pid)}`; fi"
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
      execute "rake db:migrate RAILS_ENV=#{fetch(:rails_env)} --trace"
    end
  end
end

after 'deploy:publishing', 'unicorn:restart'