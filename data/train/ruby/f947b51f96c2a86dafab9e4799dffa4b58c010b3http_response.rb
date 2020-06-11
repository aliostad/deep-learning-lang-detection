module Fiveruns::Manage::Targets::Rails::Mongrel
  
  module HttpResponse
  
    def self.included(base)
      Fiveruns::Manage.instrument base, InstanceMethods
    end
    
    def self.port_for(socket)
      if socket.respond_to?(:addr)
        # Vanilla Mongrel
        socket.addr[1]
      else
        # Swiftiply
        socket.port
      end
    end
  
    module InstanceMethods

      def start_with_fiveruns_manage(*args, &block)
        result = start_without_fiveruns_manage(*args, &block)
        port = ::Fiveruns::Manage::Targets::Rails::Mongrel::HttpResponse.port_for(socket)
        Fiveruns::Manage.tally :requests, :mongrel, nil, [:name, port]
        result
      end
      def write_with_fiveruns_manage(data, *args, &block)
        # Mongrel::HttpResponse#write(data) modifies `data', so need to get the size
        # before the method is invoked
        size = data.size
        result = write_without_fiveruns_manage(data, *args, &block)
        port = ::Fiveruns::Manage::Targets::Rails::Mongrel::HttpResponse.port_for(socket)
        Fiveruns::Manage.metrics_in :mongrel, nil, [:name, port] do |metrics|
          metrics[:bytes] += size
        end
        result              
      end
    end
    
  end
 
end

