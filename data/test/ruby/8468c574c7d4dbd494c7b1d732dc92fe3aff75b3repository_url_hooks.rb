class RepositoryUrlHooks < Redmine::Hook::ViewListener
  def view_projects_show_right(context={ })
    config = self.load_config
    project = context[:project]
    default_repository = Repository.find_by_project_id_and_is_default(project.id, 1)

    unless default_repository.nil?
      repository_basename = File.basename(default_repository.url)

      case default_repository.type
      when 'Repository::Git'
        repository_url = File.join(config['git_url'], repository_basename)
      when 'Repository::Subversion'
        repository_url = File.join(config['subversion_url'], repository_basename)
      end

      unless repository_url.nil?
        context[:controller].send(:render_to_string, {
           :partial => 'boxes/repository_url',
           :locals => { :repository_url => repository_url }
        })
      end
    end
  end

  protected
  def load_config
    config_path = "#{Rails.root}/plugins/redmine_repository_url/config/plugin.yml"
    config ||= YAML.load_file(config_path)

    if config.nil?
      raise 'Unable to load redmine_repository_url config. Check that config/plugin.yml exists.'
    end

    config[Rails.env]
  end
end