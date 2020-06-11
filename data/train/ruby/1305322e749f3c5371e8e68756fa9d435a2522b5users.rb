module SchoolFriend
  module REST
    class Users
      include APIMethods

      api_method :set_status
      api_method :get_logged_in_user,    session_only: true
      api_method :get_info,              session_only: true
      api_method :is_app_user
      api_method :has_app_permission
      api_method :remove_app_permission
      api_method :get_guests,            session_only: true
      api_method :get_calls_left
      api_method :get_current_user,      session_only: true
      api_method :get_settings
      api_method :set_settings
      api_method :get_mobile_operator
    end
  end
end