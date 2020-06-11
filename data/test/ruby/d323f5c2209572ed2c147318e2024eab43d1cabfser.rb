module Ser
  class CLI
    def start(process_names = [])
      processes(process_names).each do |process|
        if process.running?
          puts "#{process.name}: already started (#{process.pid})"
        else
          process.start
          puts "#{process.name}: started (#{process.pid})"
        end
      end
    end

    def status(process_names = [])
      processes(process_names).each do |process|
        if process.running?
          puts "#{process.name}: running (#{process.pid})"
        else
          puts "#{process.name}: not running"
        end
      end
    end

    def stop(process_names = [])
      processes(process_names).each do |process|
        if process.running?
          process.stop
          puts "#{process.name}: stopped"
        else
          puts "#{process.name}: not started"
        end
      end
    end

    def restart(process_names = [])
      processes(process_names).each do |process|
        process.restart
        puts "#{process.name}: restarted (#{process.pid})"
      end
    end

    private

    def processes(names)
      @processes ||= load_processes names
    end

    def load_processes(names = [])
      processes = []
      File.readlines('Procfile').each do |line|
        name, command = line.split(':').map(&:strip)

        if names.empty? || names.include?(name)
          processes << Process.new(name, command)
        end
      end
      processes
    end
  end

  class Process
    attr_reader :name, :command

    def initialize(name, command)
      @name, @command = name, command
    end

    def start
      ['log', 'tmp', 'tmp/pids'].each do |dir|
        Dir.mkdir dir unless Dir.exists? dir
      end
      pid = spawn command, out: logfile, err: logfile
      File.write pidfile, pid
    end

    def running?
      ::Process.kill 0, pid
    rescue Errno::ESRCH
      false
    rescue Errno::ENOENT
      false
    end

    def stop
      ::Process.kill 'SIGTERM', pid if running?
    end

    def restart
      stop
      start
    end

    def logfile
      "log/#{name}.log"
    end

    def pidfile
      "tmp/pids/#{name}.pid"
    end

    def pid
      File.read(pidfile).to_i
    end
  end
end
