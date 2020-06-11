require 'net/ssh'

namespace :simple_tasks do

  namespace :repository do
    
    repository_domain     = "<%= input[:domain] %>"
    repository_path       = "<%= input[:path] %>"
    repository_user       = "<%= input[:user] %>"
    repository_password   = "<%= input[:password] %>"

    desc "Creates a remote repository for the Rails application."
    task :create => :filter do
      puts "Creating remote repository.."
      Net::SSH.start(repository_domain, repository_user, :password => repository_password) do |ssh|
        ssh.exec "mkdir -p #{repository_path}; git --bare --git-dir=#{repository_path} init"
      end
    end
    
    desc "Removes a remote repository for the Rails application."
    task :destroy => :filter do
      puts "Removing remote repository.."
      Net::SSH.start(repository_domain, repository_user, :password => repository_password) do |ssh|
        ssh.exec "rm -rf #{repository_path}"
      end
    end
    
    desc "Adds the remote repository as origin to git."
    task :add_to_git do
      system "git remote rm origin"
      system "git remote add origin ssh://#{repository_user}@#{repository_domain}/#{repository_path}"
      puts "ssh://#{repository_user}@#{repository_domain}/#{repository_path}"
      puts "was successfully added as remote repository (origin)."
    end
    
    desc "Filters anything that might cause an error."
    task :filter do
      # => no filters added at the moment
    end
    
  end
  
end