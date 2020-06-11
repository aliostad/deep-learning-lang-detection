require 'fileutils'

module RepositoryHelpers
  TEST_REPOSITORY_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..', 'fixtures', 'repository'))

  def rebuild_repository
    destroy_repository
    create_repository
  end

  def create_repository
    FileUtils.mkdir_p TEST_REPOSITORY_PATH
    repository_command "git init"
  end

  def destroy_repository
    `rm -rf #{TEST_REPOSITORY_PATH}`
  end

  def repository_path
    TEST_REPOSITORY_PATH
  end

  def create_commit(message = "Hello world")
    extract_sha repository_command("git commit --allow-empty -m \"#{message}\"")
  end

  # Returns the short SHA from the commit output.
  #
  # Handles:
  # * [master (root-commit) e202e27] Hello # => e202e27
  # * [master 81d5b0e] Hello # => 81d5b0e
  def extract_sha(shell_output)
    if shell_output =~ /\[\w+ (\(root-commit\) )?(.*)\]/
      $2
    else
      raise RuntimeError, "could not extract SHA from #{shell_output}"
    end
  end

  def repository_command(command)
    within_repository do
      `#{command}`
    end
  end

  def within_repository
    Dir.chdir(repository_path) do
      yield
    end
  end
end
