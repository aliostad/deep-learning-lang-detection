module MailChimp
  class ApiClient
    attr_reader :api_key
  
    def initialize(api_key)
      @api_key = api_key
      @api_client = XMLRPC::Client.new_from_uri "http://#{data_center}.api.mailchimp.com/#{Base::API_VERSION}/"
    end

    def data_center
      api_key.scan(/(?:\w*)-(\w*)/).flatten.first.tap do |dc|
        raise ApiClientError.new('Api Key seems to be not valid. Unable to extract Data Center.') if dc.blank?
      end
    end

    def call(method, *args)
      @api_client.call(method, @api_key, *args)
    end
  end
end
