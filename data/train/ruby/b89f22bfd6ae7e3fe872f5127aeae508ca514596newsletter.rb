module MailchimpApiExample
  class Newsletter
    def self.subscribe(list_id: list_id, email: email)
      new(list_id)
    end

    def initialize(list_id, api_client: Mailchimp::API, api_key: ENV['MAILCHIMP_API_KEY'])
      @list_id = list_id
      @api_client = api_client.new(api_key)
    end

    def subscribe(email)
      api_client.lists.subscribe(list_id, {'email' => email }, :double_optin => false)
    end

    def api_client
      @api_client
    end

    def list_id
      @list_id
    end
  end
end
