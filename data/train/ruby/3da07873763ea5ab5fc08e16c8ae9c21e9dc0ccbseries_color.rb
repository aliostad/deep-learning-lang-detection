require 'zlib'
module PulseMeter
  module DygraphsVisualize
    class SeriesColor
      def initialize(options = {})
        @forced_color = options[:color]
        @name = options[:name] || rand.to_s
      end

      def color
        @color ||= calculate_color 
      end

      private

      def calculate_color
        @forced_color || calculate_color_by_name
      end

      def calculate_color_by_name
        '#' + hashed_color_bytes.map{|b| '%02x' % darken(b)}.join
      end

      def hashed_color_bytes
        n = Zlib::crc32(@name)
        [
          n & 0xFF,
          (n & 0xFF00) >> 8,
          (n & 0xFF0000) >> 16
        ]
      end

      def darken(byte)
        byte / 2
      end
    end
  end
end

