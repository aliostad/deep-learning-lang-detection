module ClnkApi
  class Clnk

    attr_accessor :api_key
    def initialize(api_key)
      @api_key = api_key
    end

    def shorten(url)
      link = ClnkApi::Link.new(@api_key)
      link.shorten(url)
      link
    end

    def info(url)
      link = ClnkApi::Link.new(@api_key)
      link.info(url)
      link
    end

    def expand(url)
      link = ClnkApi::Link.new(@api_key)
      link.expand(url)
      link
    end

    def bulk(urls)
      link = ClnkApi::Link.new(@api_key)
      link.bulk_shorten(urls)
      link
    end

  end
end
