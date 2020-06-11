require 'yogo/datamapper/repository_manager/model'
require 'yogo/datamapper/repository_manager/resource'

module Yogo
  module DataMapper
    module RepositoryManager
      def self.included(base)
        base.class_eval do
          extend(RepositoryManager::Model)
          include(RepositoryManager::Resource)
        end
      end      
    end # RepositoryManager
  end # DataMapper
end # Yogo

module DataMapper
  module Is
    module RepositoryManager
      def is_repository_manager
        include(Yogo::DataMapper::RepositoryManager)
      end
    end # RepositoryManager
  end # Is
  
  if const_defined?("Model")
    Model.append_extensions(Is::RepositoryManager)
  end
end # DataMapper

