require "#{File.dirname(__FILE__)}/abstract_note"

module Footnotes
  module Notes
    class ControllerNote < AbstractNote
      def initialize(controller)
        @controller = controller
      end

      def row
        :edit
      end

      def link
        if controller_filename && controller_line_number
          escape(Footnotes::Filter.prefix(controller_filename, controller_line_number + 1, 3))
        end
      end

      def valid?
        prefix?
      end

      protected
        # Some controller classes come with the Controller:: module and some don't
        # (anyone know why? -- Duane)
        def controller_filename
          return @controller_filename if defined?(@controller_filename)
          controller_name=@controller.class.to_s.underscore
          controller_name='application' if controller_name=='application_controller'
          if ActionController::Routing.respond_to? :controller_paths
            @controller_filename=nil
            ActionController::Routing.controller_paths.each do |controller_path|
              full_controller_path = File.join(File.expand_path(controller_path), "#{controller_name}.rb")
              @controller_filename=full_controller_path if File.exists?(full_controller_path)
            end
            #raise "File not found"
          else
            @controller_filename=File.join(File.expand_path(RAILS_ROOT), 'app', 'controllers', "#{controller_name}.rb").sub('/controllers/controllers/', '/controllers/')
          end
          @controller_filename
        end

        def controller_text
          if controller_filename
            @controller_text ||= IO.read(controller_filename)
          end
        end

        def action_index
          (controller_text =~ /def\s+#{@controller.action_name}[\s\(]/) if controller_text
        end

        def controller_line_number
          lines_from_index(controller_text, action_index) || 0 if controller_text
        end

        def lines_from_index(string, index)
          return nil if string.blank? || index.blank?

          lines = string.respond_to?(:to_a) ? string.to_a : string.lines.to_a
          running_length = 0
          lines.each_with_index do |line, i|
            running_length += line.length
            if running_length > index
              return i
            end
          end
        end
    end
  end
end