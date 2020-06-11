require "faraday"
require "faraday_middleware"
require "recursive-open-struct"
require "signatureio/version"
require "signatureio/document"
require "signatureio/event"

module Signatureio
  extend self

  def request=(request)
    @request = request
  end

  def request
    @request || setup_request!
  end

  def secret_api_key=(secret_api_key)
    @secret_api_key = secret_api_key
    setup_request!

    @secret_api_key
  end

  def secret_api_key
    return @secret_api_key if @secret_api_key
    ENV['SIGNATURE_SECRET_API_KEY'] || "missing_secret_api_key"
  end

  def public_api_key=(public_api_key)
    @public_api_key = public_api_key
    setup_request!

    @public_api_key
  end

  def public_api_key
    return @public_api_key if @public_api_key
    ENV['SIGNATURE_PUBLIC_API_KEY'] || "missing_public_api_key"
  end

  def api_version=(api_version)
    @api_version = api_version
    setup_request!

    @api_version
  end

  def api_version
    return @api_version if @api_version
    0
  end

  def _root_url=(_root_url)
    @_root_url = _root_url
  end

  def _root_url
    return @_root_url if @_root_url
    "https://www.signature.io"
  end

  def api_endpoint
    [_root_url, "/api/v", api_version].join
  end

  private

  def setup_request!
    options = {
      headers:  {'Accept' => "application/json"},
      ssl:      {:verify => false},
      url:      Signatureio.api_endpoint
    }

    Signatureio.request = ::Faraday::Connection.new(options) do |builder|
      builder.use     ::Faraday::Request::UrlEncoded
      builder.use     ::FaradayMiddleware::ParseJson
      builder.adapter ::Faraday.default_adapter
    end

    Signatureio.request.basic_auth(Signatureio.secret_api_key, '')

    Signatureio.request
  end
end