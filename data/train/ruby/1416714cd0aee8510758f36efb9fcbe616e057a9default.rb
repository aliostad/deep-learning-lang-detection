directory "#{node['chef_handler']['handler_path']}" do
  recursive true
  action :nothing
end.run_action(:create)

if node["platform"] != "windows"
	cookbook_file "#{node['chef_handler']['handler_path']}/notification_handler.rb" do
	  mode "0755"
	  action :nothing
	end.run_action(:create)
else 
	cookbook_file "#{node['chef_handler']['handler_path']}/notification_handler.rb" do
      action :nothing
	end.run_action(:create)
end

chef_handler "Chef::Handler::NotificationHandler" do
  source "#{node['chef_handler']['handler_path']}/notification_handler"
  action :nothing
end.run_action(:enable)
