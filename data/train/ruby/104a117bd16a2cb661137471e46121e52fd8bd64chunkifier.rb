require 'active_support/json'

module Travis
  class Worker
    class Chunkifier < Struct.new(:content, :chunk_size, :options)
      include Enumerable

      def initialize(*)
        super
        self.options ||= {}
      end

      def each(&block)
        split.each(&block)
      end

      private

        def split
          chunks = []
          current = ''

          content.scan(/.{1,#{split_size}}/m).each do |chunk|
            if too_big?(current + chunk)
              chunks << current
              current = chunk
            else
              current << chunk
            end
          end

          chunks << current if current.length > 0
          chunks
        end

        def split_size
          size = chunk_size / 10
          size == 0 ? 1 : size
        end

        def too_big?(chunk)
          chunk = to_json(chunk) if options[:json]
          chunk.bytesize > chunk_size
        end

        ENCODE_OPTIONS = { invalid: :replace, undef: :replace, replace: '?' }

        def to_json(chunk)
          chunk.to_s.force_encoding('UTF-8').encode('UTF-8', ENCODE_OPTIONS).to_json
        end
    end
  end
end
