module SbbHexagonal
  module RepositoryAdapter
    extend ActiveSupport::Concern

    included do
      @repository_name = derived_name
    end

    def repo
      self.class.repository
    end

    module ClassMethods
      # public macro to inject repository into included class
      def register_repository(name)
        @repository_name = name.to_sym
      end

      # return this class repository key
      def repository_key
        @repository_name ? @repository_name.to_sym : derived_name.to_sym
      end

      # find derived repository key from class
      # use controller, model or class name to create a key
      def derived_name
        return controller_name if respond_to?(:controller_name)
        return model_name.plural if respond_to?(:model_name)
        name ? name.underscore.pluralize : nil
      end

      # class method to find repository based on class registration or derivation
      def repository
        repo = RepositoryManager.for(repository_key)
        return repo unless repo.nil?
        # we haven't got a key lets try and make one
        begin
          RepositoryManager.create(repository_key)
        rescue NameError
          raise NameError, "Could not create #{repository_key}", caller[2..-1]
        end
      end
    end
  end
end
