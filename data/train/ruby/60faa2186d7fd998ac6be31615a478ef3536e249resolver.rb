require 'bundler'
require 'gemologist/dependency'

module Gemologist
  class Resolver
    attr_reader :repository

    def self.run(*repositories)
      repositories.flatten!.map! do |repository|
        new(repository).run
      end
    end

    def initialize(repository)
      @repository = repository
    end

    def run
      Hash[
        name:                  repository.name,
        outdated:              outdated_dependencies.any?,
        outdated_dependencies: outdated_dependencies
      ]
    end

    def dependencies
      @dependecies ||= begin
        _within_repository_root do
          Bundler::Definition.build(repository.gemfile, repository.gemfile_lock, nil).dependencies # or current_depedencies
        end
      end
    end

    def outdated_dependencies
      @outdated_dependencies ||= dependencies.map do |dependency|
        dependency = Dependency.new(dependency)
        dependency if dependency.outdated?
      end.compact
    end

    private
      def _within_repository_root
        Dir.chdir(repository.path) { yield }
      end
  end
end
