deploy_to = "/var/www/greenfootball"
app_root = "#{deploy_to}/current"
pid_file = "#{deploy_to}/shared/pids/unicorn.pid"
socket_file= "#{deploy_to}/shared/unicorn.sock"
log_file = "#{deploy_to}/shared/log/unicorn.log"
err_log = "#{deploy_to}/shared/log/unicorn_error.log"


worker_processes 2
working_directory app_root
timeout 30
listen socket_file, :backlog => 1024

pid pid_file
stderr_path err_log
stdout_path log_file
