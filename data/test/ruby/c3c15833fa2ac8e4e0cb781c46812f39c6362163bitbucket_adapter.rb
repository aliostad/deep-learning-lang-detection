require 'json'

class BitbucketAdapter

  def initialize(json)
    @payload = JSON.parse(json)['repository']

    case @payload['scm'].downcase
    when 'git'
      @scm = BitbucketGit
    when 'hg'
      @scm = BitbucketHg
    else
      raise TypeError, "Repository type (#{@payload['scm']}) not supported"
    end
  end

  def identifier
    "#{@payload['owner']}_#{@payload['slug']}"
  end

  def update_repository(repository)
    raise TypeError, "Invalid repository #{repository.identifier}" unless repository.is_a?(@scm.scm_class)
    @scm.update_repository(repository.url)
  end

  def create_repository(project)
    path = "#{@payload['owner']}/#{@payload['slug']}"

    local_root_path = Setting.plugin_redmine_bitbucket[:local_path]
    local_url = "#{local_root_path}/#{project.identifier}/#{path}"

    FileUtils.mkdir_p(local_url) unless File.exists?(local_url)

    if @scm.clone_repository(path, local_url)
      repository = @scm.scm_class.new
      repository.identifier = identifier
      repository.url = local_url
      repository.is_default = project.repository.nil?
      repository.project = project
      repository.save
      return repository
    end
  end

end
