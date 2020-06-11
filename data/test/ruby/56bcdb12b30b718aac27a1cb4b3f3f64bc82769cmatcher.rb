require 'strscan'
require 'yaml'

module Matchdoc
  class Matcher
    class FailedChunk < StandardError
      def initialize(scanner, chunk)
        failed_chunk = YAML.load(%Q(---\n"#{chunk.source}"\n))
        super("Expected `#{scanner.rest[0..failed_chunk.size-1]}` to match `#{failed_chunk}`")
      end
    end

    attr_reader :failed_chunk

    def initialize(subject)
      scanner = StringScanner.new(subject)
      @match_chunks = []
      until scanner.eos?
        break unless scanner.scan_until(/\(\?[-mix]{4}:/) #regex prefix
        @match_chunks << Regexp.new(Regexp.escape(scanner.pre_match))
        regex_sub = /\((?>[^()]|(\g<0>))*\)/.match(scanner.matched+scanner.post_match).to_s
        @match_chunks << Regexp.new(regex_sub)
        scanner.pos = scanner.pos + (regex_sub.length - 7)
        scanner.string = scanner.rest
      end
    end

    def match!(subject)
      scanner = StringScanner.new(subject)
      scanned_chunks = []
      @match_chunks.each.with_index do |chunk, i|
        unless scanned_chunks[i] = scanner.scan(chunk)
          raise FailedChunk.new(scanner, chunk)
        end
      end

      scanned_chunks
    end

    def =~(subject)
      begin
        match!(subject)
      rescue FailedChunk
        false
      else
        true
      end
    end

    def to_s
      @match_chunks.map { |i| '/' + YAML.load(%Q(---\n"#{i.source}"\n)) + '/' }.join
    end
  end
end
