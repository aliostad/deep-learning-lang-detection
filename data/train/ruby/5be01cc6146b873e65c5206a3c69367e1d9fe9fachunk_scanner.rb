module Dynosaur
  class ChunkScanner
    PATTERN = /
      ^
      (?<time>\S+)\s+           # ISO8601 timestamp
      \w+                       # Log event source
      \[(?<dyno>\w+\.\d+)\]:\s+ # Dyno name
      (?:\[\d+\]\s+)?           # Dyno PID
      (?<message>.*)            # Log message
      $
    /x

    def initialize(chunk)
      @chunk = chunk
    end

    def scan(&callback)
      @chunk.scan(PATTERN) do |time, dyno, message|
        callback.call time, dyno, message
      end
    end
  end
end
