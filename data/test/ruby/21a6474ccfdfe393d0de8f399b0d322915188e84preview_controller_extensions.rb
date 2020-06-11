module RouteHandler::PreviewControllerExtensions
  def self.included(base)
    base.class_eval do   
      
      def display_the_page_with_route_handler
        unless params[:route_handler_params].blank?
          route_handler_params = {}
          params[:route_handler_params].split("&").each do |pair|
            key, value = pair.split("=")
            route_handler_params[key.to_sym] = value
          end
          @page.route_handler_params = route_handler_params
        end
        display_the_page_without_route_handler
      end
      
      alias_method_chain :display_the_page, :route_handler
    end
  end
end