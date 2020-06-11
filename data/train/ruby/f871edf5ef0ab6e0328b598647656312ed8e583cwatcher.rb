module ProfileProbe

  class Watcher

    def initialize(config)

      @process_regex_list = config['process_regex_list'].map do |regex_str|
        Regexp.new(regex_str)
      end

      # Empty process list
      @known_process_list = ::ProcFS::ProcessList.new
      @known_socket_list = ::ProcFS::SocketList.new
    end

    def probe

      sample_time     = Time.now.utc
      socket_list     = ::ProcFS::SocketList.scan
      process_list    = ::ProcFS::ProcessList.scan(socket_list)
      process_list    = process_list.filter_by_regex(:cmdline, @process_regex_list) unless @process_regex_list.empty?
      process_deltas  = process_list - @known_process_list

      unless process_deltas.nil?
        process_deltas[:timestamp] = sample_time
      end

      @known_process_list = process_list
      @known_socket_list = socket_list

      return process_deltas
    end

  end

end