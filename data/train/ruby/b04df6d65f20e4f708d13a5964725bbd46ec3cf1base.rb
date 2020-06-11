require 'utils/logger'
require 'utils/cfg'
require 'phantom/process'

module Monitors
  module ViolationsRecorders
    class Base
      extend Logging

      class << self

        def inherited(base)
          base.instance_variable_set(:@violations, {})
        end

        @violations = {}
      
        def reset
          @violations = {}
        end

        def is_violating?(process)
          log "checking #{process}", :debug
          update_violations_count(process)
          log "#{@violations}", :debug
          violating = @violations[process.send(process_attr)] == retries_limit
          @violations[process.send(process_attr)] = 0 if violating
          violating
        end

        protected

        def update_violations_count(process)
          @violations[process.send(process_attr)] ||= 0
          if process_is_violating?(process)
            @violations[process.send(process_attr)]+= 1 
          else
            @violations[process.send(process_attr)] = 0
          end
        end

        def retries_limit
          raise NotImplementedError
        end

        def process_attr
          raise NotImplementedError
        end

        def process_is_violating?(process)
          raise NotImplementedError
        end

      end
    end
  end
end
