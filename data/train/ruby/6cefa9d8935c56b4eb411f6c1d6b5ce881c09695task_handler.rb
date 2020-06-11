require 'json'

module SWF

  # use extend, not include
  module TaskHandler

    def handle(runner, task)
      handler_class = nil
      handler       = nil
      begin

        handler_class = get_handler_class_or_fail task
        return unless handler_class
        handler = handler_class.new(runner, task)
        handler.call_handle

      rescue => e

        puts "HANDLER #{self} ERROR:"
        begin
          details_json = JSON.pretty_unparse({
            handler_class: handler_class && handler_class.name,
            handler:       handler.to_s,
            error:         e.inspect,
            backtrace:     e.backtrace,
            })
          puts details_json
          fail!(task, reason: "handler raised error", details: details_json[0...32768])
        rescue
          msg = "FAIL to handle fail!!"
          puts msg
          # failing again will cause #<RuntimeError: already responded>
          #fail!(task, reason: msg)
          raise
        end

      end
    end

    private

    def get_handler_class_or_fail(task)
      find_handler_class(task).tap {|handler_class|
        unless handler_class
          details_text = "This is a configuration issue.\n#{configuration_help_message}"
          puts details_text
          fail!(task, reason: "unknown type", details: details_text)
          return
        end
      }
    end

  end

end
