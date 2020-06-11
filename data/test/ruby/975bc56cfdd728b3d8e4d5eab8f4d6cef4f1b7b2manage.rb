user 'manage' do
    home '/home/manage'
    shell '/bin/bash'
    action :create
end

package 'nginx' do
   action :install
end

list = ['/etc/nginx/sites-available', '/home/manage', '/home/manage/log']
list.each do |l|
directory "#{l}" do
   owner 'manage'
   group 'manage'
   mode '0755'
   action :create
end
end


cookbook_file '/etc/nginx/nginx.conf' do
      source 'nginx.conf'
      mode '0755'
      action :create
end

list = ['/home/manage/log/manage-abc.com.access.log', '/home/manage/log/manage-abc.com.error.log', '/home/manage/index.html']
list.each do |f|
file "#{f}" do
  # content 'hi hello new file resource'
   content "#{ node[:vhost][:index_data] }"
   owner 'manage'
   group 'manage'
   mode '0755'
   action :create
end
end

template "/etc/nginx/sites-available/manage.conf" do
         source "manage.conf.erb"
         owner 'manage'
         group 'manage'
         mode '0755'
end

service 'nginx' do
    action :restart
end
