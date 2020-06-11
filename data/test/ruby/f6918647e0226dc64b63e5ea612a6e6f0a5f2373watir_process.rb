require 'win32/process'

module Watir
  module SpawnInNewProcess
    class Server
      attr_reader :process_id

      def initialize
        startup_command = "rubyw #{File.dirname(__FILE__)}/watir_socket.rb"
        process_info = ::Process.create('app_name' => "#{startup_command}")
        @process_id = process_info.process_id
      end
      
      def stop
        right_to_terminate_process = 1
        handle = Win32API.new('kernel32.dll', 'OpenProcess', 'lil', 'l').
        call(right_to_terminate_process, 0, @process_id)
        Win32API.new('kernel32.dll', 'TerminateProcess', 'll', 'l').call(handle, 0)
      end
        
    end
  end
end