module ProcessStatus

  class Graph

    def initialize(history)
      @history = history
    end

    def to_s
      string = ''
      @history.each do |process|
        string << build_row(process)
      end
      string
    end

    private

    def build_row(process)
      marker = process_marker(@history, process)

      row  = "#{marker}"
      row << " #{process.pid.to_s.ljust(8)}"
      row << " #{process.user.ljust(20)}"
      row << "\t#{process.cpu_usage.round(2).to_s}%"
      row << "\t#{process.command}\n"
    end

    def process_marker(history, process)
      case history.process_rank(process.pid)
      when :up
        '^'
      when :down
        'v'
      else
        ' '
      end
    end

  end

end
