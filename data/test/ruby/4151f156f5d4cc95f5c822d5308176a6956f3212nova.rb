#
execute "sync database" do
  command 'nova-manage db sync'
end

execute "create private network" do
  command "nova-manage network create vmnet " +
    "--fixed_range_v4=10.0.0.0/8 --network_size=64 --bridge_interface=eth2"
  not_if "nova-manage network list | grep 10\.0\.0\.0/"
end

execute "create public network" do
  command 'nova-manage floating create --ip_range=172.16.1.0/24'
end

execute "create admin user" do
  command 'nova-manage user admin openstack'
  not_if "nova-manage user list | grep openstack"
end

execute "add cloudamin role to the admin user" do
  command 'nova-manage role add openstack cloudadmin'
  not_if "nova-manage role has openstack cloudadmin | grep True"
end

execute "create default project for admin user" do
  command 'nova-manage project create cookbook openstack'
  not_if "nova-manage project list | grep cookbook"
end

execute "zip project files" do
  command 'nova-manage project zipfile cookbook openstack'
end

node['openstack_sandbox']['nova']['services'].each do |nova_service|
  service nova_service do
    action :restart
  end
end
