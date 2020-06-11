# setup "cvskeeper" (based on etckeeper)

include_recipe 'chef_handler::default'
include_recipe 'chef-client::config'

cookbook_file "#{node.chef_handler.handler_path}/cvskeeper-handler.rb" do
  source 'cvskeeper-handler.rb'
end

file '/etc/chef/client.d/cvskeeper-handler.rb' do
  content <<-EOQ
require '#{node.chef_handler.handler_path}/cvskeeper-handler.rb'
# For Chef < 11.10: setup default for event_handlers. CHEF-4363
event_handlers [] unless event_handlers
event_handlers << Cvskeeper::EventHandler.new
EOQ
end

chef_handler 'Cvskeeper::EventHandler' do
  source "#{node.chef_handler.handler_path}/cvskeeper-handler.rb"
  action :enable
  supports :event => true
end
