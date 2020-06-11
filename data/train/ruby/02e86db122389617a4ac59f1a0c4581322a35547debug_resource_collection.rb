# This recipe will cause the resource collection and both notification collections to
# print at the end of a chef run.

directory node['chef_handler']['handler_path'] do
  action    :nothing
  recursive true
end.run_action(:create)

handler_code = "#{node['chef_handler']['handler_path']}/resource_collection_handler.rb"
cookbook_file handler_code do
  source 'resource_collection_handler.rb'
  action :nothing
end.run_action(:create)

chef_handler 'ChefCollection' do
  source    handler_code
  action    :nothing
end.run_action(:enable)