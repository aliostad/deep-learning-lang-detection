require "knjrbfw"

class Wmctrl
  autoload :WindowProcess, "#{File.dirname(__FILE__)}/wmctrl/window_process"

  def self.focus_by_command(command)
    list = Knj::Unix_proc.list("grep" => command)

    raise "More than one process was found: #{list}" if list.length > 1
    raise "No processes was found by that command: #{command}" if list.empty?

    process = list.first

    window_process = Wmctrl::WindowProcess.list(grep: process.pid).select{ |window_process| window_process.pid == process.pid }.first
    raise "No window process with that PID: #{process.pid}" unless window_process

    window_process.focus
  end
end
