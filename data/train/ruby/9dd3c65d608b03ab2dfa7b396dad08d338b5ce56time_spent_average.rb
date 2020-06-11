require 'active_support/all'
require 'my_data_processors/support/file'
require 'my_data_processors/support/callable'
require 'my_data_processors/support/time_slice'

module MyDataProcessors
  class TimeSpentAverage
    extend MyDataProcessors::Support::Callable
    include MyDataProcessors::Support::File
    include MyDataProcessors::Support::TimeSlice

    attr_accessor :spent_on, :visit_also, :since_slice, :to_slice,
                  :slices_to_check, :filename

    def initialize(options = {})
      @filename = options[:filename]
      @spent_on = options[:spent_on]
      @visit_also = options[:visit_also]
      @slices_to_check = slice_range(options[:since], options[:to])
    end

    def process!
      process_file(filename) { |chunk| process_chunk_selection(chunk) }
      chunks_to_check.each { |chunk| process_chunk(chunk) }
      result
    end

    def process_chunk_selection(chunk)
      if chunk.id == visit_also
        chunk.data.each { |k, _| also_visitors[k] = true }
      elsif chunk.id.start_with?(spent_on)
        chunks_to_check << chunk
      end
    end

    def process_chunk(chunk)
      seconds_spent = 0

      chunk.data.each do |userid, timeslices|
        next unless also_visitors.key?(userid)
        seconds_spent += fetch_seconds_spent_in(timeslices)
      end

      seconds_per_day << seconds_spent
    end

    def result
      return 0 if seconds_per_day.size == 0
      seconds_per_day.sum / seconds_per_day.size
    end

    def also_visitors
      @also_visitors ||= {}
    end

    def chunks_to_check
      @chunks_to_check ||= []
    end

    def seconds_per_day
      @seconds_per_day ||= []
    end

    private

    def fetch_seconds_spent_in(timeslices)
      sec = 0
      slices_to_check.each do |slice|
        timeslice = timeslices[slice.to_s]
        next unless timeslice
        sec += timeslice[0].to_i
      end
      sec
    end
  end
end
