class AveragesCalculator

  def calculate_for(options = {})
    event_types = options[:event_types]
    begin_at = options[:between]
    end_at = options[:and]
    chunk_size = options[:in_chunks_of]

    averages = compute_averages(event_types, begin_at, end_at, chunk_size)
    chunks = get_time_chunks(begin_at, end_at, chunk_size)

    group_event_types_averages_and_chunks(event_types, averages, chunks)
  end


  private

  def group_event_types_averages_and_chunks(event_types, averages, chunks)
    result = {}
    averages.each do |average|
      if (result[average.event_type_id].nil?)
        result[average.event_type_id] = {}
      end
      result[average.event_type_id][average.chunk] = average.value.to_f
    end

    groups = []
    i = 0
    event_types.each do |event_type|
      groups[i] = {"event_type_id" => event_type.id, "values" => []}
      j = 0
      chunks.each do |chunk|
        if (result[event_type.id].nil?)
          groups[i]["values"][j] = {"chunk" => chunk, "value" => nil}
        else
          if (result[event_type.id][chunk].nil?)
            groups[i]["values"][j] = {"chunk" => chunk, "value" => nil}
          else
            groups[i]["values"][j] = {"chunk" => chunk, "value" => result[event_type.id][chunk]}
          end
        end
        j = j + 1
      end
      i = i + 1
    end

    groups
  end

  def get_time_chunks(begin_at, end_at, chunk_size)
    timerange = Timechunker::Timerange.new(begin_at, end_at)
    chunksize = Timechunker::Chunksize.new(chunk_size, 'minutes')

    chunker = Timechunker::Chunker.new
    chunks = chunker.get_chunks(timerange, chunksize)

    chunks_as_string = []
    chunks.each do |chunk|
      chunks_as_string << chunk.to_formatted_s(:db)
    end
    return chunks_as_string
  end

  def compute_averages(event_types, begin_at, end_at, chunk_size)
    sql = "SELECT event_type_id, AVG( value ) AS value,
            CONCAT(
              EXTRACT(YEAR FROM created_at), '-',
              LPAD(EXTRACT(MONTH FROM created_at), 2, '0'), '-',
              LPAD(EXTRACT(DAY FROM created_at), 2, '0'), ' ',
              LPAD(EXTRACT(HOUR FROM created_at), 2, '0'), ':',
              LPAD( FLOOR( EXTRACT(MINUTE FROM created_at) / ? ) * ?, 2, '0'), ':',
              '00'
            ) AS chunk,
            created_at
           FROM events
           WHERE
            event_type_id IN (?)
            AND created_at > ?
            AND created_at <= ?
          GROUP BY chunk, event_type_id
          ORDER BY chunk ASC"

    Event.find_by_sql([sql, chunk_size, chunk_size, event_types, begin_at.to_formatted_s(:db), end_at.to_formatted_s(:db)])
  end

end
