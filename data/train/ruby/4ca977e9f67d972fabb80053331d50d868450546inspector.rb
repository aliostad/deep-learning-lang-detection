module InspectorGadgit
  class Inspector
    def self.for_path(path)
      new GitRepository.new(path)
    end

    def initialize(repository)
      @repository = repository
    end

    def analyze(sha = nil)
      if sha
        analyze_sha sha
      else
        analyze_repository
      end
    end

    private

    def analyze_sha(sha)
      smells_for @repository.for_sha(sha)
    end

    def analyze_repository
      smells = []

      @repository.each_commit do |commit|
        smells.concat smells_for commit
      end

      smells
    end

    def smells_for(commit)
      SMELLS.select { |smell| smell.stinks?(commit) }
    end
  end
end
