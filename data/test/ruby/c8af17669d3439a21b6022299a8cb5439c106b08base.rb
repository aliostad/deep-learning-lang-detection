module NdTransmission
  class Base
    attr_accessor :origin, :dest, :chunk_size

    def initialize config
      self.chunk_size = config.delete(:chunk_size) || 1
      self.origin, self.dest = config.keys.first, config.values.first
    end

    def transmit
      in_chunks do |chunk|
        dest.receive chunk
      end
    end

    def in_chunks
      return to_enum(__callee__) unless block_given?

      yield origins.shift(chunk_size) while origins.any?
    end

    def origins
      @origins ||= origin.to_transmit
    end
  end
end
