module Dis
  module Fetchers
    
    class Git < Dis::Fetchers::Base
      
      def repository
        @repository ||= Dis::Tools::GitRepository.new(@options[:url], @project.source_path, :logger => project.logger)
      end
      
      def fetch!
        if repository.exist?
          current_commit = repository.last_commit
          repository.pull_rebase!(branch)
          return !(current_commit == repository.last_commit)
        else
          repository.clone!(branch)
          true
        end
      end
      
      def branch
        @options[:branch] || 'master'
      end
      
    end
    
  end
end