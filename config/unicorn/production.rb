deploy_to = "/var/www/greenfootball"

app_path = "#{deploy_to}/current"
working_directory "#{app_path}/current"
pid               "#{deploy_to}/shared/pids/unicorn.pid"

pid_file = "#{deploy_to}/shared/pids/unicorn.pid"
socket_file= "#{deploy_to}/shared/unicorn.sock"
log_file = "#{deploy_to}/shared/log/unicorn.log"
err_log = "#{deploy_to}/shared/log/unicorn_error.log"
unicorn_config_path = "#{deploy_to}/shared/config/unicorn/production.rb"

unicorn_pid "#{deploy_to}/shared/pids/unicorn.pid"
worker_processes 3
working_directory app_path
timeout 30
listen socket_file, :backlog => 1024

pid pid_file
stderr_path err_log
stdout_path log_file
