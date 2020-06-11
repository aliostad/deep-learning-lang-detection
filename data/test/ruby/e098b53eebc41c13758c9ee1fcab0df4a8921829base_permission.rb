module Permissions
  class BasePermission
    def initialize
    end

    def allow?(controller, action, resource = nil)
      controller_name = controller_name_with_version(controller)
      allowed = @allow_all || (@allowed_actions && @allowed_actions[[controller_name, action.to_s]])
      allowed && (allowed == true || resource && allowed.call(resource))
    end

    protected 
    def allow(controllers, actions, &block)
      @allowed_actions ||= {}

      Array(controllers).each do |controller|
        controller_name = controller_name_with_version(controller)
        Array(actions).each do |action|
          @allowed_actions[[controller_name, action.to_s]] = block || true
        end
      end
    end

    def allow_all
      @allow_all = true
    end

    def controller_name_with_version(controller)
      prefix = 'api/v1'
      controller_name = controller.to_s
      unless controller_name.match(prefix)  
        controller_name = "#{prefix}/#{controller_name}" 
      end
      controller_name
    end
  end
end
