module CloudFormation
  module CustomResource
    class Router
      attr_accessor :handlers, :default_handler, :config

      def self.default_router
        @@default_router ||= Router.new
      end

      def initialize
        @handlers = {}
        @config = {}
      end

      def register type, handler_class
        self.handlers[type] = handler_class
      end

      def get_handler request
        type = request['ResourceType']
        handler_class = handlers[type] || self.default_handler
        handler = handler_class.new(request, config)
      end
    end
  end
end
