require 'my_data_processors/support/file'
require 'my_data_processors/support/callable'
require 'my_data_processors/support/standard_deviation'

module MyDataProcessors
  class PageViewsSD
    extend MyDataProcessors::Support::Callable
    include MyDataProcessors::Support::File
    include MyDataProcessors::Support::StandardDeviation

    attr_accessor :identifier, :visits_filename, :spread_filename

    def initialize(options = {})
      @identifier = options[:identifier]
      @visits_filename = options[:visits_filename]
      @spread_filename = options[:spread_filename]
    end

    def process!
      process_file(visits_filename) { |chunk| process_visits_chunk(chunk) }
      process_file(spread_filename) { |chunk| process_spread_chunk(chunk) }
      result
    end

    def process_visits_chunk(chunk)
      with_chunk_in_scope(chunk) do |ch|
        ch.data.each do |_, a|
          a.each { |v| accumulate(v[1]) }
        end
      end
    end

    def process_spread_chunk(chunk)
      with_chunk_in_scope(chunk) do |ch|
        ch.data.each do |_, timeslices|
          timeslices.each do |_, a|
            accumulate(a[1])
          end
        end
      end
    end

    def result
      standard_deviation
    end

    private

    def with_chunk_in_scope(chunk, &block)
      return if chunk.id != identifier
      block.call(chunk)
    end
  end
end
