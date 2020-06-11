require 'digest/md5'
require 'fileutils'

module OpenProject::Revisions::Subversion::Hooks
  class RepoCreatorHook

    def accepts?(method, context)
      repository = context[:repository] || context[:project].repository
      return repository.is_a?(Repository::Subversion)
    end

    def project_updated(context)
      project = context[:project]

      if !project.repository.url.include?(project.repository.svn_repo_path)
        OpenProject::Revisions::Subversion.logger("Subversion repository needs to be moved!")
        #OpenProject::Revisions::Subversion::SvnAdmin.move(project.repository)
      end
    end

    def project_deletion_imminent(context)
      if context[:confirm]
        delete(context[:repository])
      end
    end

    def repository_edit_request(context)
      c = context[:controller]
      c.params[:repository] = {} unless c.params[:repository].present?
      c.params[:repository][:url] = context[:repository].svn_repo_url
    end

    def repository_edited(context)
      svnadmin = Setting.plugin_openproject_revisions_subversion[:svnadmin]
      path = context[:repository].svn_repo_path
      FileUtils.mkdir_p(path)
      OpenProject::Revisions::Shell::capture_out(svnadmin, 'create', path)
      OpenProject::Revisions::Subversion.logger.info("Created svn repo at #{path} using svnadmin.")
    rescue => e
      OpenProject::Revisions::Subversion.logger.error("Can't create svn repo #{path}: #{e.message}")
    end

    def repository_destroyed(context)
      delete(context[:repository])
    end

    private

    def delete(repository)
      if File.exists?(repository.svn_repo_path)
        OpenProject::Revisions::Subversion.logger.info("Deleting Subversion repository #{repository.svn_repo_path}")
        FileUtils.rm_rf(repository.svn_repo_path)
      end
    end

  end
end
