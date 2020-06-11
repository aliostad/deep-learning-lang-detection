require 'socket'

module EM
  class Connection
    attr_accessor :socket
    
    def initialize(*)
  
    end
    
    # user callbacks to be defined:
    # 
    # def post_init
    # def receive_data(data)
    # def unbind
    
    
    # non eventmachine method
    # 
    # def peer
    #   [@socket.peeraddr[3], @socket.peeraddr[1]]
    # end
    
    def send_data(data)
      @socket.send(data, 0)
    end
    
  end
  
  class << self
    def start_server(host, port, handler_class_or_module, *args)
      socket = TCPServer.new(host, port)
      
      monitor = self.reactor.register(socket, :r)
      monitor.value = proc do
        handler = build_handler(handler_class_or_module, *args)
        client = socket.accept_nonblock()
        handler.socket = client
        handler.post_init() if handler.respond_to?(:post_init)
        register_reader(client, handler)
      end
    
    end
    
    
    def connect(host, port, handler_class_or_module = Connection, *args)
      socket = TCPSocket.new(host, port)
      handler = build_handler(handler_class_or_module, *args)
      handler.socket = socket
      handler.post_init() if handler.respond_to?(:post_init)
      register_reader(socket, handler)
      handler
    end
    
    
    def build_handler(handler_class_or_module, *args)
      if handler_class_or_module <= Connection
        handler_class = handler_class_or_module
      else
        handler_class = Class.new(Connection)
        handler_class.send(:include, handler_class_or_module)
      end
      
      handler_class.new(*args)
    end
    
    def register_reader(socket, handler)
      $n ||= 0
      $n += 1
      
      m = self.reactor.register(socket, :r)
      m.value = proc do
        begin
          data = m.io.read_nonblock(4096)
          handler.receive_data(data) if handler.respond_to?(:receive_data)
        rescue EOFError
          handler.unbind if handler.respond_to?(:unbind)
          self.reactor.deregister(socket)
        end
      end
    end
    
  end
  
end
