require_relative 'regex'

module Readers
  class Identifier
    KEYWORDS = %w(def class if true false nil).freeze

    def initialize
      @reader = Regex.new /\A([a-z]\w*)/ do |chunk, stream, results|
        if KEYWORDS.include?(chunk)
          results[:tokens] <<= [chunk.upcase.to_sym, chunk]
        else
          results[:tokens] <<= [:IDENTIFIER, chunk]
        end
        results[:remaining_code] = stream[chunk.size..-1]
        results
      end
    end

    def read(stream, results)
      @reader.read(stream, results)
    end
  end
end
