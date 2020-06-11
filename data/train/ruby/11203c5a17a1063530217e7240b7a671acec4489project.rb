class Project < ActiveRecord::Base

  has_many :builds

  def self.build_all
    Rails.logger.info "building all?"
    Project.all.each do |project|
      next if project.builds.running.any?
      Rails.logger.info "building something #{project}?"
      Build.delay.for project.id
    end
  end

  def setup!
    clone_repository
    update_sha
    save!
  end

  def repository_path
    File.join CONTINUE_CONFIG['repositories_path'], name.parameterize, branch
  end

  def clone_repository
    FileUtils.mkdir_p repository_path

    repo = begin
      repository
    rescue ArgumentError
      Git.clone(repository_url, "#{name.parameterize}/#{branch}", :path => CONTINUE_CONFIG['repositories_path'])
    end

    repo.branch(branch).checkout
    repo
  end

  def repository_or_clone
    clone_repository
  end

  def repository
    return @repository if @repository

    repo = Git.open(repository_path)
    repo.branch(branch).checkout
    @repository = repo
  end

  def update_sha
    self.last_sha = repository.log.first.sha
  end

  def update_sha!
    update_sha
    save!
  end

  def pull_hard!
    repository.reset_hard
    clean
    repository.branch(branch).checkout
    repository.fetch
    repository.reset_hard("origin/#{branch}")
    repository.pull(repository.repo, repository.branch(branch))

    update_sha!
  end

  def clean
    repository.chdir do
      repository.status.untracked.each do |file|
        File.unlink file.first
      end
    end
  end

  def run_build
    # find build scripts in repo
    scripts = Dir.glob(File.join(repository_path, "bin", "build-*.sh"))
    scripts.collect do |script|
      runner = Runner.new
      user = `whoami`.strip
      repository.chdir do
        #runner.run "sudo su #{user} -c 'cd #{repository_path} && ls'"
        runner.run "sudo su #{user} -c 'cd #{repository_path} && BRANCH=#{branch} #{script}'"
      end

      runner
    end
  end
end
