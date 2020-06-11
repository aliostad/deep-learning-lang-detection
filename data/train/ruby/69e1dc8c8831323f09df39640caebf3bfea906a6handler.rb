module SQSPoller
  module Handler
    class << self
      def process(queue_name, msg)
        if Config['sqspoller']['queues'][queue_name]['handlers']
          Config['sqspoller']['queues'][queue_name]['handlers'].keys.each do |handler_name|
            handler = Handler.const_get(handler_name.capitalize).new
            handler_config = Config['sqspoller']['queues'][queue_name]['handlers'][handler_name]
            handler.process(queue_name, msg, handler_config)
          end
        end
      end
    end
  end
end
