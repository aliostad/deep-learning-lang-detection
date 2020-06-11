module Fiveruns::Manage::Targets::Rails::ActionMailer
  
  module Base
  
    def self.included(base)
      Fiveruns::Manage.instrument base, InstanceMethods, ClassMethods
    end
  
    module ClassMethods
      def receive_with_fiveruns_manage(*args, &block)
        Fiveruns::Manage.tally :msg_recvs, nil, nil, nil do
          receive_without_fiveruns_manage(*args, &block)
        end
      end
    end
  
    module InstanceMethods
      def deliver_with_fiveruns_manage!(*args, &block)
        Fiveruns::Manage.tally :msg_sents, nil, nil, nil do
          deliver_without_fiveruns_manage!(*args, &block)
        end
      end
    end
    
  end
  
end