module ManageAuthenticatedSystem
  protected
    # Returns true or false if the manage is logged in.
    # Preloads @current_manage with the manage model if they're logged in.
    def manage_logged_in?
      !!current_manage
    end

    # Accesses the current manage from the session. 
    # Future calls avoid the database because nil is not equal to false.
    def current_manage
      @current_manage ||= (manage_login_from_session || manage_login_from_basic_auth || manage_login_from_cookie) unless @current_manage == false
    end

    # Store the given manage id in the session.
    def current_manage=(new_manage)
      session[:manage_id] = new_manage ? new_manage.id : nil
      @current_manage = new_manage || false
    end

    # Check if the manage is authorized
    #
    # Override this method in your controllers if you want to restrict access
    # to only a few actions or if you want to check if the manage
    # has the correct rights.
    #
    # Example:
    #
    #  # only allow nonbobs
    #  def authorized?
    #    current_manage.login != "bob"
    #  end
    def manage_authorized?
      manage_logged_in?
    end

    # Filter method to enforce a login requirement.
    #
    # To require logins for all actions, use this in your controllers:
    #
    #   before_filter :login_required
    #
    # To require logins for specific actions, use this in your controllers:
    #
    #   before_filter :login_required, :only => [ :edit, :update ]
    #
    # To skip this in a subclassed controller:
    #
    #   skip_before_filter :login_required
    #
    def manage_login_required
      manage_authorized? || manage_access_denied
    end

    # Redirect as appropriate when an access request fails.
    #
    # The default action is to redirect to the login screen.
    #
    # Override this method in your controllers if you want to have special
    # behavior in case the manage is not authorized
    # to access the requested action.  For example, a popup window might
    # simply close itself.
    def manage_access_denied
      respond_to do |format|
        format.html do
          manage_store_location
          redirect_to new_manage_session_path
        end
        format.any do
          request_http_basic_authentication 'Web Password'
        end
      end
    end

    # Store the URI of the current request in the session.
    #
    # We can return to this location by calling #redirect_back_or_default.
    def manage_store_location
      session[:return_to] = request.request_uri
    end

    # Redirect to the URI stored by the most recent store_location call or
    # to the passed default.
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    # Inclusion hook to make #current_manage and #logged_in?
    # available as ActionView helper methods.
    def self.included(base)
      base.send :helper_method, :current_manage, :logged_in?
    end

    # Called from #current_manage.  First attempt to login by the manage id stored in the session.
    def manage_login_from_session
      self.current_manage = Manage.find_by_id(session[:manage_id]) if session[:manage_id]
    end

    # Called from #current_manage.  Now, attempt to login by basic authentication information.
    def manage_login_from_basic_auth
      authenticate_with_http_basic do |username, password|
        self.current_manage = Manage.authenticate(username, password)
      end
    end

    # Called from #current_manage.  Finaly, attempt to login by an expiring token in the cookie.
    def manage_login_from_cookie
      manage = cookies[:auth_token] && Manage.find_by_remember_token(cookies[:auth_token])
      if manage && manage.remember_token?
        cookies[:auth_token] = { :value => manage.remember_token, :expires => manage.remember_token_expires_at }
        self.current_manage = manage
      end
    end
end
