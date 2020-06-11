module Sipity
  module Decorators
    # Responsible for encoding the various application decorations available.
    #
    # @see #repository
    class ApplicationDecorator < Draper::Decorator
      def initialize(object, options = {})
        self.repository = options.fetch(:repository) { default_repository }
        super(object, options.except(:repository))
      end

      private

      attr_accessor :repository

      # A decorator need not have the keys to the kingdom.
      def default_repository
        QueryRepository.new
      end
    end
  end
end
