module PartiUrlHelper
  def auth_api_url()
    "http://#{auth_api_host}:#{auth_api_port}"
  end

  def auth_api_host()
    ENV['AUTH_API_HOST'] or 'auth-api'
  end

  def auth_api_port()
    correct_docker_link_port ENV['AUTH_API_PORT'], 3030
  end

  def users_api_url(path = '/')
    base_url = "http://#{users_api_host}:#{users_api_port}"
    URI::join(base_url, path).to_s
  end

  def users_api_host()
    ENV['USERS_API_HOST'] or 'users-api'
  end

  def users_api_port()
    correct_docker_link_port ENV['USERS_API_PORT'], 3030
  end

  private

  def correct_docker_link_port(port, default)
    case port
    when /^(\d+)$/
      $1.to_i
    when /^tcp:\/\/.+:(\d+)$/
      $1.to_i
    else
      default
    end
  end

end
