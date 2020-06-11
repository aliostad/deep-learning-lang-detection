require 'fileutils'

class GitService

  include Builder::GitHelper

  attr_reader :remote_repository_path, :local_repository_path, :scm_branch_name
  attr_accessor :log

  SCM_REPO = 'https://github.com/ahsandar/command-service.git'

  def initialize(options={})
    defaults = {:local_repository_root_path => LOCAL_REPO_PATH,
                :repository_path=> SCM_REPO }
    options = defaults.merge(options)
    validate_repository(options)
    post_initializer(options)
  end

  def validate_repository(options)
    unless  options.has_key?(:repository_path) && !options[:repository_path].empty?
      raise ScmServiceException.new "No remote repository_path supplied or is empty"
    end
    unless options.has_key?(:local_repository_root_path) && !options[:local_repository_root_path].empty?
      raise ScmServiceException.new "No local local_repository_root_path path supplied or is empty"
    end
  end

  def post_initializer(options)
    repo_path_and_branch(options[:repository_path], options[:branch])
    local_repository_dir(options[:local_repository_root_path])
    services_initialize(options[:logger])
  end

  def check_out(options={},&block)
    reset_local_repository local_repository_path
    defaults = {:action=>'clone',
                :source=> remote_repository_path,
                :destination => local_repository_path,
                :branch => scm_branch_name}

    create_repo(defaults.merge(options), &block)
  end

  private

  def repo_path_and_branch(repo, branch)
    @remote_repository_path = repo
    @scm_branch_name = branch
  end

  def services_initialize(logger = nil)
    @log ||=  logger || LogService.new('git')
    log.msg "local_repository_path .... #{local_repository_path.inspect}"
  end

  def local_repository_dir(local_repository_root_path)
    @local_repository_path = File.expand_path File.join( local_repository_root_path, "#{repository_name remote_repository_path}" )
    FileUtils.mkpath local_repository_root_path unless File.exists?(@local_repository_path)
  end

  def create_repo(options, &block)
    begin
      result = execute_git_command(options, remote_repository_path)
      yield result if block_given?
    rescue Exception => e
      log.msg "********** Exception in Git process **********"
      log.msg "#{e.message}"
      log.msg "#{e.backtrace.join("\n")}"
      raise ScmServiceException.new "Cannot connect to git repository : #{remote_repository_path}"
    ensure
      reset_local_repository local_repository_path if File.exists?(local_repository_path)
    end
    result
  end

end

class ScmServiceException < Exception
end
