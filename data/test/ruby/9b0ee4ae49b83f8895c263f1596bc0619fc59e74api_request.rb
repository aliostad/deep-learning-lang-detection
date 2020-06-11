class ApiRequest
  def initialize(params:, headers:, env:)
    @params = params
    @headers = headers
    @env = env
  end

  def validate!
    return if Rails.env.test?

    raise UnauthorisedApiKeyError unless key_infos.present?
  end

  def key_infos
    Api::ApplicationKey.new(api_key: api_key).key_infos
  end

  def api_key
    headers['X-API-KEY'] || env['X-API-KEY'] || env['HTTP_X_API_KEY'] || env['HTTP_API_KEY']
  end

  private
  attr_reader :params, :headers, :env
end

class UnauthorisedApiKeyError < StandardError; end