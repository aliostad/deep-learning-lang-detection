module YhsdApi

  class Account < YhsdApi::Base

    def self.all(token, params = nil)
      path = "accounts#{handle_query_string(params)}"
      uri = URI.join(YhsdApi.configuration.api_url, YhsdApi.configuration.api_version, path)
      YhsdApi::HTTP::get(uri, build_header(token))
    end

    def self.count(token)
      path = "accounts/count"
      uri = URI.join(YhsdApi.configuration.api_url, YhsdApi.configuration.api_version, path)
      YhsdApi::HTTP::get(uri, build_header(token))
    end

    def self.find(token, id, params = nil)
      path = "accounts/#{id}#{handle_query_string(params)}"
      uri = URI.join(YhsdApi.configuration.api_url, YhsdApi.configuration.api_version, path)
      YhsdApi::HTTP::get(uri, build_header(token))
    end

  end

end