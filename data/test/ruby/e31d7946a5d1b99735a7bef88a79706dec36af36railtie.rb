module Shinji
  class Railtie < Rails::Railtie
    event_handlers = [
      Shinji::EventHandler::ActiveRecord::Sql,
      Shinji::EventHandler::ActionView::RenderTemplate,
      Shinji::EventHandler::ActionView::RenderPartial,
      Shinji::EventHandler::ActionController::ProcessAction,
      Shinji::EventHandler::ActionMailer::Deliver,
    ]

    config.after_initialize do
      event_handlers.each do |handler|
        handler.register
        Shinji.registered_event_handlers << handler
      end
    end
  end
end
