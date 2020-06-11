require 'json'

module Echos
  module BasePacket
    def +(other)
      fail TypeError unless other.class == Hash
      body.merge!(other)
    end

    def body
      { uuid: uuid }
    end

    def uuid
      SecureRandom.uuid
    end
  end

  Packet = Struct.new(:process) do
    include BasePacket

    def body
      super.merge!({ process_stdout: process.out,
                     process_stderr: process.err,
                     process_exitstatus: process.status.exitstatus,
                     process_runtime: process.runtime,
                     process_pid: process.status.pid })
    end
  end

  TimeoutPacket = Struct.new(:process) do
    include BasePacket

    def body
      super.merge!({ process_runtime: -1 })
    end
  end
end
