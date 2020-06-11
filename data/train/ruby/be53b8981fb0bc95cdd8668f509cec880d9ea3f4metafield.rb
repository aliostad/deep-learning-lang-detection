module YhsdApi

  class Metafield < YhsdApi::Base

    def self.count(token)
      path = "metas/count"
      uri = URI.join(YhsdApi.configuration.api_url, YhsdApi.configuration.api_version, path)
      YhsdApi::HTTP::get(uri, build_header(token))
    end

    def self.all(token, params = nil)
      path = "metas#{handle_query_string(params)}"
      uri = URI.join(YhsdApi.configuration.api_url, YhsdApi.configuration.api_version, path)
      YhsdApi::HTTP::get(uri, build_header(token))
    end

    def self.find(token, id, params = nil)
      path = "metas/#{id}#{handle_query_string(params)}"
      uri = URI.join(YhsdApi.configuration.api_url, YhsdApi.configuration.api_version, uri)
      YhsdApi::HTTP::get(uri, build_header(token))
    end

    def self.create(token, params)
      path = "metas"
      uri = URI.join(YhsdApi.configuration.api_url, YhsdApi.configuration.api_version, path)
      YhsdApi::HTTP::post(uri, params.to_json, build_header(token))
    end

    def self.update(token, id, params)
      path = "metas/#{id}"
      uri = URI.join(YhsdApi.configuration.api_url, YhsdApi.configuration.api_version, path)
      YhsdApi::HTTP::put(uri, params.to_json, build_header(token))
    end

    def self.delete(token, id)
      path = "metas/#{id}"
      uri = URI.join(YhsdApi.configuration.api_url, YhsdApi.configuration.api_version, path)
      YhsdApi::HTTP::delete(uri, build_header(token))
    end

    def self.update_fields(token, id, params)
      path = "metas/#{id}/fields"
      uri = URI.join(YhsdApi.configuration.api_url, YhsdApi.configuration.api_version, path)
      YhsdApi::HTTP::post(uri, params.to_json, build_header(token))
    end

    def self.find_fields(token, id, params = nil)
      path = "metas/#{id}/fields#{handle_query_string(params)}"
      uri = URI.join(YhsdApi.configuration.api_url, YhsdApi.configuration.api_version, path)
      YhsdApi::HTTP::get(uri, build_header(token))
    end

  end

end