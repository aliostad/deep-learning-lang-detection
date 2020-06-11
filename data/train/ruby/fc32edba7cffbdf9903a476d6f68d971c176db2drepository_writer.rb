module Torutsume
  module Git
    class RepositoryWriter
      attr_reader :error

      def initialize(repository_creator: _, repository_loader: _, commit_writer: _)
        @repository_creator = repository_creator
        @repository_loader = repository_loader
        @commit_writer = commit_writer
      end

      def create(user: user, text: text)
        repo  = @repository_creator.create(text)
        @commit_writer.write(repository: repo, user: user, text: text, initial: true)

        repo
      rescue => e
        @error = e
        nil
      end

      def update(user: user, text: text, message: nil)
        repo  = @repository_loader.load(text)
        @commit_writer.write(repository: repo, user: user, text: text, message: message)

        repo
      rescue => e
        @error = e
        nil
      end
    end
  end
end
