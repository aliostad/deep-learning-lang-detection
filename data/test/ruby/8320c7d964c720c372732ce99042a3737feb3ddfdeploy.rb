set :application, "solve"
set :app_url, "tackleit.de"
# ---------------------------------------------------------------------------
set :ssh_options, { :user => "root", :port => 10122, :forward_agent => true }
set :use_sudo, false

set :repository,  "svn+ssh://svn@192.168.100.103/#{application}/"
set :local_repository, "svn+kd://#{app_url}/#{application}/"
set :scm, :subversion

set :deploy_to, "/var/www/#{application}"
set :deploy_via, :export

role :web, "#{app_url}"                          # Your HTTP server, Apache/etc
role :app, "#{app_url}"                          # This may be the same as your `Web` server
role :db,  "#{app_url}", :primary => true        # This is where Rails migrations will run

before "deploy", :ask_for_repository
before "deploy:symlink", :chown_dir

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

task :chown_dir do
  run "chown -R #{application}:#{application} #{deploy_to}"
end

task :ask_for_repository do
  type = Capistrano::CLI.ui.ask("Checkout Trunk, Branch or Tag (trunk|branch|tag)[trunk]: ")

  if type == 'branch'
    set :repository, repository + 'branches/releases/'
    set :local_repository, local_repository + 'branches/releases/'
  elsif type == 'tag'
    set :repository, repository + 'tags/'
    set :local_repository, local_repository + 'tags/'
  else
    set :repository, repository + 'trunk'
    set :local_repository, local_repository + 'trunk'
  end

  if ['branch', 'tag'].include? type
    name = Capistrano::CLI.ui.ask("Which name for #{repository}: ")
    set :repository, "#{repository}" + (name.strip.empty? ? default : name)
    set :local_repository, "#{local_repository}" + (name.strip.empty? ? default : name)
  end

  puts "Using repository: " + repository
  puts "Using local_repository: " + local_repository
end
