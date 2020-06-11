class ExternalProcess
  # Path to output file. Defaults to /dev/null
  attr_accessor :output_file

  def initialize(exec_args)
    @process = nil
    @process_reader = nil
    @process_builder = java.lang.ProcessBuilder.new(exec_args)
    @process_builder.redirectErrorStream(true)
    output_file = '/dev/null'
  end

  def environment
    @process_builder.environment
  end

  def start
    raise 'Process is already running' if running?
    @process = @process_builder.start
    redirect_input_stream(@process.getInputStream)
  end

  def running?
    @process_reader and @process_reader.alive?
  end

  def stop
    raise 'Process is not running' unless running?
    @process.destroy
    @process.waitFor
    @process = nil
    @process_reader = nil
  end

  private
  def redirect_input_stream(input_stream)
    @process_reader = Thread.new do 
      buffered_reader = java.io.BufferedReader.new(java.io.InputStreamReader.new(input_stream))
      output = File.new(output_file, 'w')
      line = ''
      while not line.nil?
        output.write line + "\n"
        line = buffered_reader.readLine
      end
      buffered_reader.close
    end
    nil
  end
end
