class API::RootController < API::ApplicationController
  # GET /api/
  def index
    render json: {
      _links: {
        #self url
        self:     { href: api_root_path },
        #history stream for resources
        history:  { href: api_history_path },
        #resources
        apps:     { href: api_apps_path },
        contacts: { href: api_contacts_path },
        servers:  { href: api_servers_path },
        users:    { href: api_users_path },
        locations: { href: api_locations_path },
        operating_systems: { href: api_operating_systems_path },
        #hook for generators
      }
    }
  end
end
