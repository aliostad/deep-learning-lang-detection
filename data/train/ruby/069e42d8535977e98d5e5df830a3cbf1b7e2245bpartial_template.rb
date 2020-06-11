module Fiveruns::Manage::Targets::Rails::ActionView
  
  # For Rails >= 2.1.0 && < 2.2.0, when ActionView#Base partial rendering
  # was refactored into PartialTemplate
  module PartialTemplate

    def self.included(base)
      Fiveruns::Manage.instrument base, InstanceMethods
    end
    
    def self.complain?
      return false if Fiveruns::Manage::Version.rails <  Fiveruns::Manage::Version.new(2, 1, 0)
      return false if Fiveruns::Manage::Version.rails >= Fiveruns::Manage::Version.new(2, 2, 0)
      true
    end

    module InstanceMethods
      def render_with_fiveruns_manage(*args, &block)
        Fiveruns::Manage::Targets::Rails::ActionView::Base.record path do
          render_without_fiveruns_manage(*args, &block)
        end
      end
    end
    
  end

end