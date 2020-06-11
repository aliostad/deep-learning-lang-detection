module Goliath::Chimp
  module Rack::Validation
    class RouteHandler
      include Goliath::Rack::Validator
      
      attr_reader :route_key, :handler_map

      def initialize(app, key, map = {})
        @app = app
        @route_key = key
        @handler_map = map
      end

      def call env
        endpoint = env['routes'][route_key] rescue nil
        name, handler = handler_map.detect{ |name, handler| name === endpoint }
        if handler
          env['handler'] = handler          
          @app.call env
        else
          validation_error(400, "No handler found for #{route_key} <#{endpoint}>")
        end
      end      
    end
  end
end
