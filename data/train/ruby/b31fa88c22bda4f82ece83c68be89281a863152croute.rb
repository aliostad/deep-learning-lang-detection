module Diaoduapi #nodoc
  module Routing #nodoc
    module MapperExtensions
      def diaodu_routes
        @set.add_route("/api/register.:format",{:namespace => "api", :controller => "client", :action => "register"})
        @set.add_route("/api/update.:format",{:namespace => "api", :controller => "client", :action => "update"})
        @set.add_route("/api/get_channel.:format",{:namespace => "api", :controller => "client", :action => "create_channel"})
        @set.add_route("/api/destroy_channel.:format",{:namespace => "api", :controller => "client", :action => "destroy_channel"})
        @set.add_route("/api/channel_notice.:format",{:namespace => "api", :controller => "client", :action => "notice_channel"})
        @set.add_route("/api/change_password.:format",{:namespace => "api", :controller => "client", :action => "password"})
        @set.add_route("/api/upload_file.:format",{:namespace  => "api", :controller => "client", :action => "upload_file"})
        @set.add_route("/api/get_tid_ssip.:format",{:namespace  => "api", :controller => "client", :action => "get_tid_ssip"})
        @set.add_route("/api/device_report.:format",{:namespace  => "api", :controller => "client", :action => "device_report"})
        @set.add_route("/api/checkupdate.:format",{:namespace  => "api", :controller => "client", :action => "checkupdate"})

        @set.add_route("/api/archived.:format", {:namespace => "api", :controller => "server", :action => "save_archived"})
        @set.add_route("/api/live.:format", {:namespace => "api", :controller => "server", :action => "save_live"})
        @set.add_route("/api/location.:format", {:namespace => "api", :controller => "server", :action => "location"})
        @set.add_route("/api/server_token.:format", {:namespace => "api", :controller => "server", :action => "server_token"})
        @set.add_route("/api/login.:format", {:namespace => "api", :controller => "server", :action => "login"})
        @set.add_route("/api/upload.:format", {:namespace => "api", :controller => "server", :action => "upload"})
      end
    end
  end
end

ActionController::Routing::RouteSet::Mapper.send :include, Diaoduapi::Routing::MapperExtensions
