module Timechunker
  class Chunker

    def get_chunks(timerange, chunksize)
      if chunksize.type == 'minutes'
        number_of_chunks = ((timerange.end_time - timerange.start_time) / 60 / chunksize.size).ceil.to_i
        number_of_chunks = number_of_chunks + 1

        first_chunk = find_chunk(timerange.start_time, chunksize)

        chunks = []
        number_of_chunks.times do |i|
          chunk = first_chunk + (i * 60 * chunksize.size)
          chunks << chunk unless chunk > timerange.end_time
        end

        return chunks

      end
    end


    private

    def find_chunk(time, chunksize)
      if chunksize.type == 'minutes'
        first_chunk = Time.local(time.year,
                                 time.month,
                                 time.day,
                                 time.hour,
                                 time.min / chunksize.size * chunksize.size,
                                 0)
      end
    end

  end
end
