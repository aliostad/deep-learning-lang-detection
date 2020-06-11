module WaveZutaZuta
  module Sampler
    class Renderer
      include Sampler

      def to_wave
        data_size = fmt_chunk.length + data_chunk.length + 4

        wave_data = "RIFF"
        wave_data << [data_size].pack("l")
        wave_data << "WAVE"
        wave_data << fmt_chunk
        wave_data << data_chunk
        wave_data
      end

      private
      def play_pcm(pcm_data)
        @pcm_body ||= ''
        @pcm_body << pcm_data
      end

      def fmt_chunk
        fmt_chunk = "fmt "
        fmt_chunk << [16].pack("l")
        fmt_chunk << [@pcm_meta.format].pack("s")
        fmt_chunk << [@pcm_meta.channels].pack("s")
        fmt_chunk << [@pcm_meta.samplerate].pack("l")
        fmt_chunk << [@pcm_meta.bytepersec].pack("l")
        fmt_chunk << [@pcm_meta.blockalign].pack("s")
        fmt_chunk << [@pcm_meta.bitswidth].pack("s")
        fmt_chunk
      end

      def data_chunk
        data_chunk = "data"
        data_chunk << [@pcm_body.length].pack("l")
        data_chunk << @pcm_body
        data_chunk
      end
    end
  end
end
