# -*- encoding: utf-8 -*-

module SendGrid4r::REST
  #
  # SendGrid Web API v3 ApiKeysManagement
  #
  module ApiKeysManagement
    include Request

    ApiKeys = Struct.new(:result)
    ApiKey = Struct.new(:name, :api_key_id, :api_key, :scopes)

    def self.url(api_key_id = nil)
      url = "#{BASE_URL}/api_keys"
      url = "#{url}/#{api_key_id}" unless api_key_id.nil?
      url
    end

    def self.create_api_keys(resp)
      return resp if resp.nil?
      api_keys = resp['result'].map do |api_key|
        ApiKeysManagement.create_api_key(api_key)
      end
      ApiKeys.new(api_keys)
    end

    def self.create_api_key(resp)
      return resp if resp.nil?
      ApiKey.new(
        resp['name'],
        resp['api_key_id'],
        resp['api_key'],
        resp['scopes']
      )
    end

    def get_api_keys(&block)
      resp = get(@auth, ApiKeysManagement.url, &block)
      finish(resp, @raw_resp) { |r| ApiKeysManagement.create_api_keys(r) }
    end

    def post_api_key(name:, scopes: nil, &block)
      params = { name: name }
      params[:scopes] = scopes unless scopes.nil?
      resp = post(@auth, ApiKeysManagement.url, params, &block)
      finish(resp, @raw_resp) { |r| ApiKeysManagement.create_api_key(r) }
    end

    def get_api_key(api_key_id:, &block)
      endpoint = ApiKeysManagement.url(api_key_id)
      resp = get(@auth, endpoint, &block)
      finish(resp, @raw_resp) { |r| ApiKeysManagement.create_api_key(r) }
    end

    def delete_api_key(api_key_id:, &block)
      delete(@auth, ApiKeysManagement.url(api_key_id), &block)
    end

    def patch_api_key(api_key_id:, name:, &block)
      params = { name: name }
      endpoint = ApiKeysManagement.url(api_key_id)
      resp = patch(@auth, endpoint, params, &block)
      finish(resp, @raw_resp) { |r| ApiKeysManagement.create_api_key(r) }
    end

    def put_api_key(api_key_id:, name:, scopes:, &block)
      params = {}
      params[:name] = name unless name.nil?
      params[:scopes] = scopes unless scopes.nil?
      endpoint = ApiKeysManagement.url(api_key_id)
      resp = put(@auth, endpoint, params, &block)
      finish(resp, @raw_resp) { |r| ApiKeysManagement.create_api_key(r) }
    end
  end
end
