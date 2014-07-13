namespace :nginx do
  nginx_process = '/etc/init.d/nginx'
  [:start, :stop, :restart].each do |command|
    desc "nginx - #{command}"
    task command do
      on roles(:web) do
        execute :sudo, nginx_process, command.to_s
      end
    end
  end

  desc "nginx - status"
  task :status do
    on roles(:web) do
      info capture(nginx_process, ' status; true')
    end
  end
end
