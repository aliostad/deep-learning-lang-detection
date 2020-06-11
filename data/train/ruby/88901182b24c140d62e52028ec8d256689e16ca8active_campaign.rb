require_relative "active_campaign/version"
require 'httparty'

module ActiveCampaign
  class Client
    attr_accessor :api_key, :ac_uri
    include HTTParty


    def initialize(ac_uri, api_key, api_output = 'json')
      @api_key    = api_key
      @ac_uri     = ac_uri
      @api_output = api_output
      self.class.base_uri "#{@ac_uri}/admin/api.php"
    end

    def list_add(params={})
      raise ArgumentError, 'Query params must be a hash' unless params.is_a?(Hash)
      params.merge!({api_key: @api_key, api_action: 'list_add', api_output: @api_output})
      self.class.post('/', body: params)
    end

    def list_field_add(params={})
      params.merge!({api_key: @api_key, api_action: 'list_field_add', api_output: @api_output})
      self.class.post('/', body: params)
    end

    def list_list(params={})
      params.merge!({api_key: @api_key, api_action: 'list_list', api_output: @api_output})
      self.class.get('/', query: params)
    end

    def contact_add(params={})
      params.merge!({api_key: @api_key, api_action: 'contact_add', api_output: @api_output})
      self.class.post('/', body: params)
    end

    def contact_edit(params={})
      params.merge!({api_key: @api_key, api_action: 'contact_edit', api_output: @api_output})
      self.class.post('/', body: params)
    end

    def message_add(params={})
      params.merge!({api_key: @api_key, api_action: 'message_add', api_output: @api_output})
      self.class.post('/', body: params)
    end

    def campaign_create(params={})
      params.merge!({api_key: @api_key, api_action: 'campaign_create', api_output: @api_output})
      self.class.post('/', body: params)
    end

    def campaign_send(params={})
      params.merge!({api_key: @api_key, api_action: 'campaign_send', api_output: @api_output})
      self.class.get('/', query: params)
    end
  end
end
