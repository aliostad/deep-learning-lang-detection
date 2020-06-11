module Modgen
  module API
    class APIRequest < Request
      
      attr_reader :api_method

      # Create APIRequest
      #
      # == Parameters:
      # api_method:: Modgen::API::Method
      # data::
      #   Hash
      #     {
      #       'path'   => {},
      #       'params' => {},
      #       'body'   => {}
      #     }
      #
      def initialize(api_method, data)
        @api_method = api_method

        super(@api_method.url, data, @api_method.http_method.downcase)
      end

      private

        def _response
          response = Modgen::Session.get.execute(self)
          
          Modgen::API::APIResponse.new(response, self)
        end

    end
  end
end
