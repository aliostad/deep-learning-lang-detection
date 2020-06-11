#
# Cookbook Name:: email_handler
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
chef_gem "pony" do
  action :install
end

include_recipe "chef_handler"
include_recipe "postfix"
include_recipe "mailx"

cookbook_file "#{node['chef_handler']['handler_path']}/email_handler.rb" do
  source "handlers/email_handler.rb"
  owner "root"
  group "root"
  mode "0644"
end

chef_handler "MyCompany::EmailMe" do
  source "#{node['chef_handler']['handler_path']}/email_handler.rb"
  arguments [node['email_handler']['from_address'],
             node['email_handler']['to_address']]
  action :enable
end
