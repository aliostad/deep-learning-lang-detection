module PVC
  class ProcessPiece

    class Runner
      def initialize(*args)
        @args = args
        @process = ChildProcess.build(*args)
      end

      def stdin
        @process.io.stdin
      end

      def start(following_piece)
        @process.duplex = true
        @process.io.stdout = following_piece.stdin
        @process.io.stderr = following_piece.errin if following_piece.respond_to?(:errin)
        @process.start
      end

      def finish
        @process.io.stdin.close
        @process.wait
      end

      def code
        @process.exit_code
      end
    end

    def initialize(*args)
      @args = args
    end

    def runner
      Runner.new(*@args)
    end

  end
end

