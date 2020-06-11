set :default_branch, branch

# ##### ask for different branch and repository
set :branch do
    input_branch = default_branch
    if interactive_mode
        input_branch = Capistrano::CLI.ui.ask "<-- Insert the branch: [#{default_branch}] "
        input_branch = default_branch if input_branch.empty?
    end

    if input_branch == 'master'
        abort 'Error you are in Staging you cannot deploy from master'
    end
    #return
    input_branch
end
set :repository do
    input_repository_vendor = repository_vendor
    if interactive_mode
        input_repository_vendor = Capistrano::CLI.ui.ask "<-- Insert the repository vendor: [#{repository_vendor}] "
        input_repository_vendor = repository_vendor if input_repository_vendor.empty?
    end
    #return
    "git@github.com:#{input_repository_vendor}/#{application}.git"
end