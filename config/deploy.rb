# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "qna"
set :repo_url, "git@github.com:pavelukr/qna.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/qna"
set :deploy_user, 'deployer'
#set :passenger_restart_with_touch, true
set :pty,  false
# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/master.key"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system",
                                  'public/uploads', 'public/packs', '.bundle', 'node_modules', 'vendor/bundle'

#before "deploy:assets:precompile", "deploy:yarn_install"

namespace :deploy do

  # desc 'Run rake yarn:install'
  # task :yarn_install do
  #   on roles(:web) do
  #     within release_path do
  #       #execute("cd #{release_path} && yarn install")
  #     end
  #   end
  # end

  namespace :sidekiq do

    task :restart do
      invoke 'sidekiq:stop'
      invoke 'sidekiq:start'
    end

    before 'deploy:finished', 'sidekiq:restart'

    task :stop do
      on roles(:app) do
        within current_path do
          pid = p capture "ps aux | grep sidekiq | awk '{print $2}' | sed -n 1p"
          execute("kill -9 #{pid}")
        end
      end
    end

    task :start do
      on roles(:app) do
        within current_path do
          execute :bundle, "exec sidekiq -e #{fetch(:stage)} -C config/sidekiq.yml -d"
        end
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      #execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end
