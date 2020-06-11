execute "update packages" do
  not_if "pidof zypper"
  command "zypper -q --no-gpg-checks ref && " +
    "zypper -q -no-gpg-checks up -y -t package"
end

include_recipe "chef_handler"

cookbook_file "#{node["chef_handler"]["handler_path"]}/reboot_handler.rb" do
  source "reboot_handler.rb"
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

chef_handler "AAAA::RebootHandler" do
  source "#{node["chef_handler"]["handler_path"]}/reboot_handler.rb"
  supports :report => true
  action :enable
end

