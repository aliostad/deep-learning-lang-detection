module Oceanarium
  module Config
    extend self

    # API URL getter/setter
    def api_url=(api_url)
      @api_url = api_url
      @api_url
    end

    def api_url
      return @api_url if @api_url
      "https://api.digitalocean.com/"
    end

    # API key getter/setter.
    def api_key=(api_key)
      @api_key = api_key
      @api_key
    end

    def api_key
      return @api_key if @api_key
      nil
    end

    # Client key getter/setter.
    def client_id=(client_id)
      @client_id = client_id
      @client_id
    end

    def client_id
      return @client_id if @client_id
      nil
    end
  end
end
