class FluQ::Format::Lines < FluQ::Format::Base
  include MonitorMixin

  # @see FluQ::Format::Base#initialize
  def initialize(*)
    super
    @buffer = ""
  end

  protected

    # @see FluQ::Format::Base#parse_each
    def parse_each(chunk)
      last_chunk = nil
      synchronize do
        @buffer << chunk
        @buffer.each_line do |line|
          line.chomp!
          next if line.empty?

          last_chunk = yield(line) ? nil : line
        end
        last_chunk ? @buffer = last_chunk : @buffer.clear
      end
    end

end
