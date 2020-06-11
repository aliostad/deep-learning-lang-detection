module AgworldApi
  class Client
    attr_reader :url, :api_token

    def initialize(url: nil, api_token: nil)
      @url = url
      @api_token = api_token
      AgworldApi::Endpoints::Base.site = "#{url}?api_token=#{api_token}"
    end

    def companies
      AgworldApi::Endpoints::Company
    end

    def farms
      AgworldApi::Endpoints::Farm
    end

    def fields
      AgworldApi::Endpoints::Field
    end

    def seasons
      AgworldApi::Endpoints::Season
    end

    def activities
      AgworldApi::Endpoints::Activity
    end
  end
end
