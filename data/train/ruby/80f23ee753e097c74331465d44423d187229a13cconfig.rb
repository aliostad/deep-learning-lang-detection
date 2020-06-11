module LinkShrink
  # @author Jonah Ruiz <jonah@pixelhipsters.com>
  # Configurable module for Shrinkers-related settings
  module Config
    extend self

    # @!attribute api_key
    # @return [String] API key to be used
    attr_accessor :api_key

    # Sets API to be used
    # @param api [String or Symbol] api to be used
    def api=(api)
      @api = LinkShrink::Shrinkers.const_get(api).new
    end

    # Returns API used
    #   Uses Google by default
    # @return [LinkShrink::Shrinkers::Google] instance
    def api
      @api || LinkShrink::Shrinkers::Google.new
    end
  end
end