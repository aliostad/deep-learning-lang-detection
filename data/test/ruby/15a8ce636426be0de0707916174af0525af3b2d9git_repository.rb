require 'commit_activity/git/command'
module CommitActivity
  class GitRepository
    attr_accessor :repository
    def initialize(repository)
      @repository = repository
    end

    def log(since: nil)
      options = {
        '--branches' => nil,
        '--pretty'   => '%cN,%ct'
      }
      options['--since'] = since.to_s unless since.nil?
      CommitActivity::Git::Command.new.execute(
        repository: @repository,
        subcommand: '--no-pager log',
        options:    options
      ) 
    end

  end
end
