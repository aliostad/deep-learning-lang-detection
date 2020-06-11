module Gitar
  module Environment
    module ClassMethods
      
      class RepositoryError < StandardError ; end
      
      def git?
        true
      end
      
      def default_repository=(location)
        @@default_repository = File.expand_path(location) rescue nil
      end
      
      def default_repository
        raise RepositoryError.new('No default repository set') unless @@default_repository
        unless repository_exists?(@@default_repository)
          @@repository = Git.init(@@default_repository)
        else
          @@repository = Git.open(@@default_repository)
        end
      end
      
      def repository_exists?(name)
        File.directory?(name + '/.git')
      end
      
    end

    module InstanceMethods

      def repository_exists?
        self.class.repository_exists?(@repository_name)
      end
      
      def document_path
        [repository.dir.path, id].join('/')
      end
  
  
      private

      def create_or_find_default_repository
        @repository ||= self.class.default_repository
      end

    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end