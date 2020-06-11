include_recipe 'chef_handler'

message   = node['campfire_handler']['message']
token     = node['campfire_handler']['token']
room_id   = node['campfire_handler']['room_id']
subdomain = node['campfire_handler']['subdomain']

cookbook_file "#{node['chef_handler']['handler_path']}/campfire.rb" do
  source 'campfire.rb'
  action :nothing
end.run_action(:create)

chef_handler "Chef::Handler::Campfire" do
  source "#{node['chef_handler']['handler_path']}/campfire"
  arguments [ subdomain, token, room_id, message ]
  action :nothing
  supports :report => false, :exception => true
end.run_action(:enable)
