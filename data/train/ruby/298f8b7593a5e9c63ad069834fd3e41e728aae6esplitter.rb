module EventMachine
  module Twilio
    class Splitter
      SMS_MAX_CHARACTERS = 160
      include Enumerable

      def initialize(text)
        @text = text
      end

      def each(&block)
        split(@text).each do |chunk|
          block.call(chunk)
        end
      end

      private

      def split(text, chunk_size = SMS_MAX_CHARACTERS)
        chunks = []
        chunk = ""
        text.dup.split(/ /).each do |word|
          if word.size > chunk_size
            chunk = truncate(word, chunk_size)
          elsif chunk.size + word.size >= chunk_size
            chunks << chunk.dup unless chunk.blank?
            chunk = word
          else
            chunk += chunk.empty? ? word : " #{word}"
          end
        end
        chunks << chunk
        chunks.reject! { |c| c.strip.empty? }
        chunks
      end

      def truncate(text, size)
        text.dup[0..(size-4)] + "..."
      end
    end
  end
end
