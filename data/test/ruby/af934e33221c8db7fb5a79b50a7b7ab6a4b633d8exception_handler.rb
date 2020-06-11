#
# Cookbook Name:: handler_demo
# Recipe:: exception_handler
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
chef_gem "pony" do
	action :install
end

package 'mailx'

include_recipe "chef_handler"

cookbook_file "#{node['chef_handler']['handler_path']}/exception_handler.rb" do
	source "handlers/exception_handler.rb"
	owner "root"
	group "root"
	mode "0644"
end

chef_handler "NcrDemo::EmailMe" do
	source "#{node['chef_handler']['handler_path']}/exception_handler.rb"
	arguments [node['handler_demo']['from_address'],
		node['handler_demo']['to_address']]
	action :enable
end

