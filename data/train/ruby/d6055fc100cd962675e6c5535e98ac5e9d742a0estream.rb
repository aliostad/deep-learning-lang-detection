# encoding: utf-8

module Grooveshark
  class Stream
    attr_reader :size

    def initialize stream, song
      @stream, @song, @size = stream, song, 0
    end

    def dump output
      each_chunk { |chunk| output.write chunk }
    end

    def each_chunk
      Net::HTTP.start @stream[:ip] do |http|
        req = Net::HTTP::Post.new '/stream.php'
        http.request req, "streamKey=#{@stream[:key]}" do |res|
          @size = res.header['Content-Length'].to_i

          res.read_body { |chunk| yield chunk }
        end
      end
    end

    def to_s
      %{#<#{self.class.name}:#{@song.id} @stream=#{@stream.inspect}>}
    end
  end
end
