module Piv
  module Helpers
    module Shell

      def more(text = nil, flags=[:R],overwrites={})
        out = overwrites[:out] || STDOUT
        err = overwrites[:err] || STDERR

        flags = flags.any? ? "-" + flags.join : ''

        # use ChilProcess for cross compatibility
        more_process           = ChildProcess.new("more", flags)

        more_process.duplex    = true
        more_process.io.stdout = out
        more_process.io.stderr = err
        more_process.start

        more_process.io.stdin.write(text) if text
        yield(more_process.io.stdin)      if block_given?

        more_process.io.stdin.close
        more_process.wait
      end

    end
  end
end
