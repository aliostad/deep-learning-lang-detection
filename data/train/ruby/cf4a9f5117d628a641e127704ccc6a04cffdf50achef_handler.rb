include_recipe "chef_handler"

if node.prometheus_client.chef_handler.type == "file"
  directory node.prometheus_client.node_exporter.file_path do
    action :create
    recursive true
  end
end

cookbook_file "#{node.chef_handler.handler_path}/prometheus.rb" do
  action :create
  source "chef-handler-prometheus-#{node.prometheus_client.chef_handler.type}.rb"
end

chef_handler "PrometheusHandler" do
  action :enable
  source "#{node.chef_handler.handler_path}/prometheus.rb"
  arguments({
    file_path:  node.prometheus_client.node_exporter.file_path
  })
end