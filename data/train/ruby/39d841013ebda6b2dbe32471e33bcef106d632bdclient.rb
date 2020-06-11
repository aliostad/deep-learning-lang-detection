module ZillowSnatcher

  API_KEY = YAML.load_file("api_key.yml")
  LANDLORDS = YAML.load_file("landlords.yml")
  API_URL = "http://api.rentalapp.zillow.com/#{API_KEY["api_key"]}/listings.json"

  class Client
    attr_accessor :url

    def fetch_json(url)
      puts "Connecting to Zillow API and fetching JSON from: #{url}"
      @api_response = JSON.parse(open(url).read)
      @api_response.each { |key, value| puts "#{key}: #{value}" }
    end

    def api_response
      @api_response
    end

    def listings
      api_response['listings']
    end

  end

end
