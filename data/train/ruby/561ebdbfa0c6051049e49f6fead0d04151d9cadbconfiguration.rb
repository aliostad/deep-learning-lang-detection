module Clamd
  class Configuration
    attr_accessor :host, :port, :open_timeout, :read_timeout, :chunk_size

    ##
    # Default configuration for Clamd

    DEFAULTS = {
      host: 'localhost',
      port: 9321,
      open_timeout: 5,
      read_timeout: 30,
      chunk_size: 10240
    }

    def initialize
      self.host = DEFAULTS[:host]
      self.port = DEFAULTS[:port]
      self.open_timeout = DEFAULTS[:open_timeout]
      self.read_timeout = DEFAULTS[:read_timeout]
      self.chunk_size = DEFAULTS[:chunk_size]
    end
  end
end
