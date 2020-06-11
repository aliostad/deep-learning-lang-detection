module Gitlog
  class Repository

    attr_reader :repository, :name, :title, :path

    def initialize(repository)
      config ||= Gitlog::Config.new
      @config = config.repository(repository)
      if @config.nil?
        @repository = nil
      else
        begin
          @repository ||= Grit::Repo.new @config[:path]
          @name = repository
          @title = @config[:title]
          @path = @config[:path]
        rescue Grit::NoSuchPathError
          @repository = nil
        end
      end
    end

    def branches
      @repository.branches
    end

    def commits(*args)
      @repository.commits *args
    end

    def commits_since(*args)
      @repository.commits_since *args
    end

    def commits_between(from, to)
      @repository.commits_between(from, to)
    end

    def commit(id)
      @repository.commit(id)
    end

    def diff(*args)
      @repository.diff *args
    end

    def log(*args)
      @repository.log *args
    end

    def tree *args
      @repository.tree *args
    end

    def tags
      @repository.tags
    end

    def tree *args
      @repository.tree *args
    end

    def lstree *args
      @repository.lstree *args
    end

  end
end
