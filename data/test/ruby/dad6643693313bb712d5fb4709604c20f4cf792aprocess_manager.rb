module MediaPlayer
  # execute, stop, pause, resume
  class ProcessManager
    attr_accessor :current_process_id

    def build_process(media_file)
      Process.spawn("play #{media_file}")
    end

    def execute(media_file)
      @current_process_id = build_process(media_file)
    end

    def pause
      Process.kill(:STOP, @current_process_id)
    end

    def resume
      Process.kill(:CONT, @current_process_id)
    end

    def stop
      begin
        Process.kill(:INT, @current_process_id)
        Process.waitpid(@current_process_id)
      rescue
      end
    end

    def is_current_process_alive?
      begin
        Process.getpgid(@current_process_id)
        true
      rescue Errno::ESRCH
        false
      rescue
        false
      end
    end
  end
end

