require 'rocketamf'
require 'net/rtmp/chunk'
require 'net/rtmp/header'
require 'net/rtmp/message'

module Net
  class RTMP
    class Envelope < RocketAMF::Envelope
      def chunks(chunk_stream_id: 3, chunk_type: 0, chunk_size: 128)
        data = serialize
        total_chunks = (data.size / chunk_size.to_f).ceil

        total_chunks.times.map do |i|
          chunk_start = chunk_size * i
          chunk_end = chunk_start + chunk_size - 1

          current_chunk_type = i == 0 ? 0 : chunk_type

          timestamp = time_since_epoch
          timestamp = chunks[i - 1].timestamp - timestamp if i > 0 && [1, 2].include?(chunk_type)

          Chunk.new(message_stream_id: message.stream_id,
                    message_type_id: message.type_id,
                    chunk_stream_id: chunk_stream_id,
                    chunk_type: current_chunk_type,
                    timestamp: timestamp,
                    data: data[chunk_start..chunk_end])
        end
      end

      private

      def time_since_epoch
        (Time.now.to_f * 1000).to_i
      end
    end
  end
end
