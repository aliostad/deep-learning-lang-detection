require 'spec_helper'

describe Gitolite::ForkableRepository do
  it_behaves_like :repository_decorator do
    def decorate(repository)
      Gitolite::ForkableRepository.new(repository, double('shell'))
    end
  end

  describe '#create_fork' do
    it 'executes a Gitolite fork command' do
      repository = double(host: 'example.com', path: 'source/path')
      shell = Gitolite::FakeShell.new
      forkable_repository = Gitolite::ForkableRepository.new(repository, shell)

      forkable_repository.create_fork('target/path')

      expect(shell).to have_executed_command(
        'ssh git@example.com fork source/path target/path'
      )
    end
  end
end
