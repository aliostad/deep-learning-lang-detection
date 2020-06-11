#
# requires modular_class_name to be defined
#
# also makes use of @controller_class_name value
#
module AuthorizedRailsScaffolds::Macros::ControllerMacros

  # The namespaced class the Controller inherits from (i.e. Example::ApplicationController)
  def application_controller_class
    @application_controller_class = 'ApplicationController'
    if parent_modules.any?
      @application_controller_class = "#{parent_modules.join('::')}::#{@application_controller_class}"
    end
    @application_controller_class
  end

  def controller_class_name
    controller_class_prefix = @controller_class_name || modular_class_name.pluralize
    "#{controller_class_prefix}Controller"
  end

end