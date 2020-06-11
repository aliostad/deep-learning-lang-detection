module Dabster
  module Whatcd
    class ArtistSource

      attr_reader :api_connection, :api_cache, :artist_class

      def initialize(api_connection, api_cache, artist_class)
        @api_connection, @api_cache, @artist_class = api_connection, api_cache, artist_class
      end

      def find(filter)
        raise(ArgumentError, 'requires id key') if !filter.key?(:id)
        if !artist = api_cache.artist(filter)
          artist = api_connection.make_request(filter.merge(action: 'artist'))
          api_cache.cache_artist(id: artist[:id], response: artist)
        end
        artist_class.new(artist)
      end

    end
  end
end
