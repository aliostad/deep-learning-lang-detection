module Fiveruns::Manage::Targets::Rails::Mongrel
  
  module HttpServer
  
    def self.included(base)
      Fiveruns::Manage.instrument base, InstanceMethods
    end
  
    module InstanceMethods
      # FIXME: this probe is firing but not storing anything. WTF?
      def process_client_with_fiveruns_manage(*args, &block)
        result = process_client_without_fiveruns_manage(*args, &block)
        Fiveruns::Manage.metrics_in :mongrel, nil, [:name, self.port] do |metrics|
          metrics[:workers] = self.workers.list.length
        end
        result
      end
    end
    
  end
 
end