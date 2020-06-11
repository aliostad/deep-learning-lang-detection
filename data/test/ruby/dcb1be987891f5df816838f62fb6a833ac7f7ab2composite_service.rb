require 'salemove/process_handler'
require 'salemove/process_handler/composite_process'
require 'salemove/process_handler/cron_process'
require 'salemove/process_handler/pivot_process'

module Salemove

  class EchoResultService
    QUEUE = 'Dummy'

    def call(params={})
      puts "RESULT"
    end
  end

  class Messenger
    def respond_to(*)
      ResponderHandler.new
    end
  end

  class ResponderHandler
    def shutdown
    end
  end

  cron_process = ProcessHandler::CronProcess.new
  cron_process.schedule('0.5')
  cron_process.schedule('5', some: 'params')

  ProcessHandler::PivotProcess.logger = Logger.new('/dev/null')
  pivot_process = ProcessHandler::PivotProcess.new(Messenger.new)

  ProcessHandler.start_composite do
    add cron_process, EchoResultService.new
    add pivot_process, EchoResultService.new
  end

end
