require 'lastfm'
require 'mini_magick'
require_relative 'user'
require_relative 'album'

module LastFm

  def self.client
      @client ||= Lastfm.new(@@api_key, @@api_secret)
  end

  def self.api_key=(_api_key)
    @@api_key = _api_key
  end

  def self.api_secret=(_api_secret)
    @@api_secret = _api_secret
  end

  def self.artwork_formats
    {
      :iphone => {
        :rows => 6,
        :cols => 4,
        :size => 160
      },
      :ipad => {
        :rows => 8,
        :cols => 6,
        :size => 256
      }
    }
  end

end
