module Fiveruns::Manage::Targets::Rails::ActionController
  
  module Base
  
    def self.included(base)
      Fiveruns::Manage.instrument base, ClassMethods, InstanceMethods
    end
    
    module ClassMethods
      
      # Page Caching
      def cache_page_with_fiveruns_manage(*args, &block)
        Fiveruns::Manage.tally :pages_caches, nil, nil, nil do
          cache_page_without_fiveruns_manage(*args, &block)
        end
      end
      def expire_page_with_fiveruns_manage(*args, &block)
        Fiveruns::Manage.tally :pages_expires, nil, nil, nil do
          expire_page_without_fiveruns_manage(*args, &block)
        end
      end
      
    end
            
    module InstanceMethods
      def process_with_fiveruns_manage(request, *args, &block)
        # Kickoff new reporter if necessary (if forked)
        ::Fiveruns::Manage::Plugin.reporter.start
        result = nil
        action = (request.parameters['action'] || 'index').to_s
        Fiveruns::Manage.context = [:controller, (controller = self.class.name), :action, action]
        context = [:controller, (controller = self.class.name)]
        time = Fiveruns::Manage.stopwatch { result = process_without_fiveruns_manage(request, *args, &block) }
        Fiveruns::Manage.metrics_in :action, context, [:name, action] do |metrics|
          metrics[:reqs] += 1
          metrics[:proc_time] += time
          metrics[:bytes] += Fiveruns::Manage.bytes_this_request
        end
        Fiveruns::Manage.metrics_in :controller, context, [:name, controller] do |metrics|
          metrics[:reqs] += 1
          metrics[:proc_time] += time
          metrics[:bytes] += Fiveruns::Manage.bytes_this_request
        end
        Fiveruns::Manage.context = nil
        Fiveruns::Manage.bytes_this_request = 0
        result
      end
      def rescue_action_with_fiveruns_manage(*args, &block)
        result = rescue_action_without_fiveruns_manage(*args, &block)
        Fiveruns::Manage.tally :rescues, :action, Fiveruns::Manage.context, [:name, Fiveruns::Manage.action_in_context]
        Fiveruns::Manage.tally :rescues, :controller, Fiveruns::Manage.context, [:name, Fiveruns::Manage.controller_in_context]
        result
      end
      
      # Fragment Caching
      def write_fragment_with_fiveruns_manage(*args, &block)
        Fiveruns::Manage.tally :frag_caches, nil, nil, nil do
          write_fragment_without_fiveruns_manage(*args, &block)
        end
      end
      def expire_fragment_with_fiveruns_manage(*args, &block)
        Fiveruns::Manage.tally :frag_expires, nil, nil, nil do
          expire_fragment_without_fiveruns_manage(*args, &block)
        end
      end
      
    end
  
  end

end