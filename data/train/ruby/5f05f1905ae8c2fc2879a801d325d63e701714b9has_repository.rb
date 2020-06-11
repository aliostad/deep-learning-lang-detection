module Cyrax::Extensions
  module HasRepository
    extend ActiveSupport::Concern

    included do
      class_attribute :_repository_class
      class_attribute :_repository_options
    end

    def repository_class
      options[:repository] || self.class._repository_class || Cyrax::Repository
    end

    def repository
      options = (self.class._repository_options || {}).merge(
        as: accessor, resource_class: resource_class, params: params
      )
      repository_class.new(options)
    end

    module ClassMethods
      def inherited(subclass)
        subclass._repository_options = self._repository_options.try(:clone)
      end

      def repository(name = nil, &block)
        if name.is_a?(Symbol)
          klass, finder_name = nil, name
        elsif name.is_a?(String)
          ActiveSupport::Deprecation.warn "sending String in #decorator method is deprecated. send Class instead"
          klass, finder_name = name.constantize, nil
        elsif name.present?
          klass, finder_name = name, nil
        end

        if klass.present?
          self._repository_class = klass
        end
        if block_given?
          self._repository_options = self._repository_options.try(:clone)
          self._repository_options ||= {}
          self._repository_options[:finders] ||= {}
          self._repository_options[:finders][finder_name || :scope] = block
        end
      end
    end
  end
end
