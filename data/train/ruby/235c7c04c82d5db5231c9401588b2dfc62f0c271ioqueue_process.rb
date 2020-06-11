module MongoMapper
  module Acts
    module IOQueueProcess
      
      def self.included(base)
        base.extend IOQueueProcessClassMethods
      end
      
      module IOQueueProcessClassMethods
        def acts_as_ioqueue_process(options = {})
          include MongoMapper::Acts::IOQueueProcess::IOQueueProcessInstanceMethods
          extend MongoMapper::Acts::IOQueueProcess::IOQueueProcessSingletonMethods
          
          require 'process_state'
          
          attr_accessor :interval, :persistent_object
        end
      end
      
      module IOQueueProcessInstanceMethods
        def initialize(options = {})
          options.each_pair do |key, value|
            self.send("#{key}=", value) if self.respond_to?("#{key}=")
          end
          
          @interval.update_attributes(:state => ProcessState::PROCESSING)
          self.process
          @interval.update_attributes(:state => ProcessState::PROCESSED)
        end
        
        
        
      end
      
      module IOQueueProcessSingletonMethods
        
      end
    end
  end
end