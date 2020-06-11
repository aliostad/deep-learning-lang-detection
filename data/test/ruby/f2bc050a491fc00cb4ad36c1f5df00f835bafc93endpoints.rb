module KISSmetrics
  module Endpoints
    CORE_API = '/core'
    QUERY_API = '/query'

    ENDPOINTS = {
      account: {
        path: '/accounts',
        api:  CORE_API
      },
      product: {
        path: '/products',
        api: CORE_API
      },
      event: {
        path: '/events',
        api: CORE_API
      },
      metric: {
        path: '/metrics',
        api: CORE_API
      },
      property: {
        path: '/properties',
        api: CORE_API
      },
      report: {
        path: '/reports',
        api: CORE_API
      }
    }

    def base_url
      'https://api.kissmetrics.com'
    end

    def version_path
      ''
    end

    def endpoint_for(resource)
      ENDPOINTS[resource][:api] + ENDPOINTS[resource][:path]
    end
  end
end
