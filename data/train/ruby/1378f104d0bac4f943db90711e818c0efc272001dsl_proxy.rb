require 'cognizant/util/dsl_proxy_methods_handler'

module Cognizant
  class Process
    class DSLProxy
      include Cognizant::Util::DSLProxyMethodsHandler

      def initialize(process, &dsl_block)
        super
        @process = process
        instance_eval(&dsl_block)
      end

      def check(condition_name, options, &block)
        @process.check(condition_name, options, &block)
      end

      def monitor_children(&child_process_block)
        @process.monitor_children(&child_process_block)
      end
    end
  end
end
