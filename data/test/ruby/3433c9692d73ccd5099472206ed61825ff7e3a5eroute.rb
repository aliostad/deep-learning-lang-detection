module SimpleController
  class Router
    class Route
      attr_reader :controller_path, :action_name

      def initialize(controller_path, action_name)
        @controller_path, @action_name = controller_path, action_name
      end

      def call(params, context, controller_path_block)
        controller_class = controller_path_block ? controller_path_block.call(controller_path) : "#{controller_path}_controller".classify.constantize

        params = { 'controller' => controller_path, 'action' => action_name }.reverse_merge(params)
        controller_class.call action_name, params, context
      end
    end
  end
end