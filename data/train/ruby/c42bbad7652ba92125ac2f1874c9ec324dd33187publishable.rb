module Bongloy
  module ApiKey
    class Publishable
      attr_accessor :api_key

      def initialize(api_key)
        self.api_key = api_key
      end

      def valid?
        !!api_key && remote_valid?
      end

      private

      def remote_valid?
        begin
          Bongloy::ApiResource::Token.new(:api_key => api_key).save!
        rescue Bongloy::Error::Api::InvalidRequestError
          true
        rescue Bongloy::Error::Api::AuthenticationError
          false
        end
      end
    end
  end
end
