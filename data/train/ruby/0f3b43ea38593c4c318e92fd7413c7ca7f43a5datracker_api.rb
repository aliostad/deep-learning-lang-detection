class TrackerApi
  API_BASE_PATH = "https://www.pivotaltracker.com/services/v3"
  API_TOKEN_KEY = :api_token

  attr_reader :api_token
  attr_reader :session_key

  class << self
    def login(options)
      if api_token = options[:api_token].presence
        # this makes a quick API call to see if the api token is correct
        RestClient.get(API_BASE_PATH + '/activities?limit=1', self.default_headers(api_token) )
      elsif options[:username].present? && options[:password].present?
        response = RestClient.post(API_BASE_PATH + '/tokens/active', username: options[:username], password: options[:password])
        api_token = Nokogiri::XML(response.body).search('guid').inner_html
      end

      api_token.blank? ? nil : self.new(api_token)

    rescue RestClient::Unauthorized
      nil
    end

    def default_headers(api_token)
      { 'X-TrackerToken' => api_token }
    end
  end

  def initialize(api_token)
    @api_token   = api_token
    @session_key = new_session_key
  end

  private

  def new_session_key
    @api_token.blank? ? nil : "#{@api_token}-#{Time.now.to_f}"
  end
end
