module Fixtures::GitBare
  extend ActiveSupport::Concern

  included do
    before(:each) do
      @repository_path = File.expand_path('tmp/git').freeze
      @repository = Rugged::Repository.init_at(@repository_path, bare: true)
      @repository.config['core.worktree'] = File.expand_path("spec/project")
      @repository.config['core.bare'] = false
      Superconductor.config.repository_path = @repository_path
      Superconductor.reset!
    end

    let(:repository) { @repository }
    let(:repository_path) { @repository_path }

    after(:each) do
      system('rm', '-rf', @repository_path)
    end
  end

end
