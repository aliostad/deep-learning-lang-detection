class RepositoryDownloadWorker
  require 'fileutils'
  require 'git'

  attr_accessor :repository, :working_directory

  def self.perform(repository_id, allow_existing_repository)
    self.new.perform(repository_id, allow_existing_repository)
  end

  def perform(repository_id, allow_existing_repository = false)
    @repository = Repository.find(repository_id)
    create_tmp_directory!
    if allow_existing_repository
      download_or_use_existing_repository!
    else
      download_repository!
    end
  end

  def clean_up
    destroy_working_directory!
  end

  protected

  def block_repository!
    @repository.update_attribute(:blocked, true)
  end

  def unblock_repository!
    @repository.update_attribute(:blocked, false)
  end

  def create_tmp_directory!
    destroy_working_directory!
    FileUtils::mkdir_p(working_directory)
  end

  def download_or_use_existing_repository!
    download_repository! unless File.directory?(repository_working_directory)
  end

  def download_repository!
    git_working_directory_from_clone
  end

  def in_working_directory(&block)
    Dir.chdir(repository_working_directory, &block)
  end

  def repository_working_directory
    "#{working_directory}/#{@repository.name}"
  end

  def destroy_working_directory!
    #FileUtils.rm_rf(working_directory)
  end

  def working_directory
    @working_directory ||= "#{Rails.root}/tmp/#{@repository.name}"
  end

  private

  def git_working_directory_from_clone
    # TODO use key
    Git.clone(@repository.github_url, @repository.name, :path => working_directory)
  end
end
