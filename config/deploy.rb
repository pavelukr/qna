# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "qna"
set :repo_url, "git@github.com:pavelukr/qna.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/qna"
set :deploy_user, 'deployer'

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/master.key"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system",
                                  'public/uploads', 'public/packs', '.bundle', 'node_modules'


namespace :deploy do
  desc 'Run assets_precompile'
  task :assets_precompile do
    on roles(:web) do
      within release_path do
        # execute("echo $PATH")
        # execute("which yarn")
        #execute("cd #{release_path} && /home/happyagent/.volta/bin/yarn install")
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end
