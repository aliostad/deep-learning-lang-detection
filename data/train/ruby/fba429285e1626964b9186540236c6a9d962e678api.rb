module Pidgey
  class Api
    include HTTParty

    base_uri 'https://sendgrid.com/api/'

    attr_reader :api_user, :api_key

    # Creates a new API client.
    # @param [String] api_user sengrid api username
    # @param [String] api_key sengrid api key
    # @return [Pidgey::API] the API client
    def initialize(api_user, api_key)
      @api_user = api_user
      @api_key = api_key
    end

    include ::Pidgey::List
    include ::Pidgey::Email
    include ::Pidgey::Newsletter
    include ::Pidgey::Newsletter::Schedule
    include ::Pidgey::Newsletter::Recipient

    def get(path, options)
      options[:query].merge!({ api_user: @api_user, api_key: @api_key })
      response = self.class.get(path, options).parsed_response

      return JSON.parse(response)
    end

    def post(path, options = {})
      options[:body].merge!({ api_user: @api_user, api_key: @api_key })
      response = self.class.post(path, options).parsed_response

      return JSON.parse(response)
    end
  end
end
