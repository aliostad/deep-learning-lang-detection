require 'baremetrics_api/endpoint/account'
require 'baremetrics_api/endpoint/annotations'
require 'baremetrics_api/endpoint/charges'
require 'baremetrics_api/endpoint/customers'
require 'baremetrics_api/endpoint/events'
require 'baremetrics_api/endpoint/goals'
require 'baremetrics_api/endpoint/metrics'
require 'baremetrics_api/endpoint/plans'
require 'baremetrics_api/endpoint/sources'
require 'baremetrics_api/endpoint/subscriptions'
require 'baremetrics_api/endpoint/users'

module BaremetricsAPI
  class Constants
    API_HOST = 'https://api.baremetrics.com/v1'.freeze
    SANDBOX_API_HOST = 'https://api-sandbox.baremetrics.com/v1'.freeze
    CONFIG_KEYS = [:api_key, :response_limit, :sandbox, :log_traffic].freeze
    DEFAULT_RESPONSE_LIMIT = 30

    # Endpoints
    ENDPOINT_CLASSES = [BaremetricsAPI::Endpoint::Account, BaremetricsAPI::Endpoint::Annotations, BaremetricsAPI::Endpoint::Charges,
                        BaremetricsAPI::Endpoint::Customers, BaremetricsAPI::Endpoint::Events, BaremetricsAPI::Endpoint::Goals,
                        BaremetricsAPI::Endpoint::Metrics, BaremetricsAPI::Endpoint::Plans, BaremetricsAPI::Endpoint::Sources,
                        BaremetricsAPI::Endpoint::Subscriptions, BaremetricsAPI::Endpoint::Users].freeze
  end
end
