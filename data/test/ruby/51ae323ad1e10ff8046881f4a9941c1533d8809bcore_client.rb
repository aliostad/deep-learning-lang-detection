module Imagga
  class CoreClient
    include Imagga::Exceptions
    attr_reader :api_key, :api_secret, :base_uri

    def initialize(opts={})
      @api_key     = opts[:api_key]    || raise_missing(:api_key)
      @api_secret  = opts[:api_secret] || raise_missing(:api_secret)
      @base_uri    = opts[:base_uri]   || raise_missing(:base_uri)
    end

    def extract(options={})
      ExtractCommand.new(api_key, api_secret, base_uri).execute(options)
    end

    def rank(options={})
      RankCommand.new(api_key, api_secret, base_uri).execute(options)
    end

    def crop(options={})
      CropCommand.new(api_key, api_secret, base_uri).execute(options)
    end
  end
end

