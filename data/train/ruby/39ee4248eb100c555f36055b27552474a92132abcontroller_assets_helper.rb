module RailsControllerAssets
  # ActionView helper methods module
  module ControllerAssetsHelper
    def controller_stylesheets
      styles = []
      styles << controller_stylesheet if controller_stylesheet?
      styles << controller_and_action_stylesheet if controller_and_action_stylesheet?
      styles
    end

    def controller_and_action
      [controller_path, action_name].join('_')
    end

    def controller_stylesheet?
      controller_asset?(:css)
    end

    def controller_and_action_stylesheet?
      controller_and_action_asset?(:css)
    end

    def controller_javascripts
      scripts = []
      scripts << controller_javascript if controller_javascript?
      scripts << controller_and_action_javascript if controller_and_action_javascript?
      scripts
    end

    def controller_javascript?
      controller_asset?(:js)
    end

    def controller_and_action_javascript?
      controller_and_action_asset?(:js)
    end

    def controller_asset?(type)
      asset_exists? controller_asset(type)
    end

    def controller_and_action_asset?(type)
      asset_exists? controller_and_action_asset(type)
    end

    def asset_exists?(asset)
      Rails.application.assets.find_asset(asset).tap do |found|
        if Rails.env.development?
          Rails.logger.info "  \e[1m\e[33m[RailsControllerAssets]\e[0m Asset `#{asset}' was #{'not ' unless found}found"
        end
      end
    end

    def controller_asset(type)
      "#{controller_path}.#{type}"
    end

    def controller_and_action_asset(type)
      "#{controller_and_action}.#{type}"
    end

    def controller_javascript
      controller_asset(:js)
    end

    def controller_and_action_javascript
      controller_and_action_asset(:js)
    end

    def controller_stylesheet
      controller_asset(:css)
    end

    def controller_and_action_stylesheet
      controller_and_action_asset(:css)
    end

    def skip_controller_stylesheet!
      controller_stylesheets.delete(controller_stylesheet)
    end
  end
end
