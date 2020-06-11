module Net::SNMP
  class TrapHandler
    include Net::SNMP::Debug
    extend Forwardable

    attr_accessor :listener, :v1_handler, :v2_handler, :inform_handler, :message, :pdu
    def_delegators :listener, :start, :run, :listen, :stop, :kill

    def initialize(&block)
      @listener = Net::SNMP::Listener.new
      @listener.on_message(&method(:process_trap))
      self.instance_eval(&block)
    end

    private

    def process_trap(message)
      case message.pdu.command
      when Constants::SNMP_MSG_TRAP
        handler = V1TrapDsl.new(message)
        handler.instance_eval(&v1_handler)
      when Constants::SNMP_MSG_TRAP2
        handler = V2TrapDsl.new(message)
        handler.instance_eval(&v2_handler)
      when Constants::SNMP_MSG_INFORM
        handler = V2InformDsl.new(message)
        handler.instance_eval(&inform_handler)
      else
        warn "Trap handler received non-trap PDU. Command type was: #{message.pdu.command}"
      end
      message.pdu.free
    end

    def v1(&handler)
      @v1_handler = handler
    end

    def v2(&handler)
      @v2_handler = handler
    end

    def inform(&handler)
      @inform_handler = handler
    end
  end
end
