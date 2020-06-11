require 'redmine'

require 'private_repository/repositories_helper_patch'
require 'private_repository/user_patch'
require 'private_repository/changeset_patch'
require 'private_repository/application_helper_patch'
require 'dispatcher'

Dispatcher.to_prepare :redmine_private_repository do
  unless RepositoriesHelper.included_modules.include? PrivateRepository::RepositoriesHelperPatch
    RepositoriesHelper.send(:include, PrivateRepository::RepositoriesHelperPatch)
  end
  unless User.included_modules.include? PrivateRepository::UserPatch
    User.send(:include, PrivateRepository::UserPatch)
  end
  unless Changeset.included_modules.include? PrivateRepository::ChangesetPatch
    Changeset.send(:include, PrivateRepository::ChangesetPatch)
  end
  unless ApplicationHelper.included_modules.include? PrivateRepository::ApplicationHelperPatch
    ApplicationHelper.send(:include, PrivateRepository::ApplicationHelperPatch)
  end
end


Redmine::Plugin.register :redmine_private_repository do
  name 'Private Repository'
  author 'Oleg Kandaurov'
  description 'Adds ability to make private repositories.'
  version '0.0.1'
  author_url 'http://okandaurov.info'
  url 'https://github.com/f0y/redmine_private_repository'
  project_module :repository do
    permission :view_private_repositories, {}
  end

end
