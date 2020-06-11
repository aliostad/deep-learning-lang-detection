module NavigationHelper
  def home_active
    'active' if 'welcome#bootstrap' == "#{controller.controller_name}##{controller.action_name}"
  end

  def stats_active
    'active' if 'statistics' == "#{controller.controller_name}"
  end

  def trips_active
    'active' if 'trips' == controller.controller_name && controller.action_name != 'new'
  end

  def new_trip_active
    'active' if 'trips' == controller.controller_name && controller.action_name == 'new'
  end

  def users_active
    'active' if 'users' == controller.controller_name
  end

  def about_active
    'active' if 'welcome#about' == "#{controller.controller_name}##{controller.action_name}"
  end
end
