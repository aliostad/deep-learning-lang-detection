#
# Cookbook Name:: simple_slack_handler
# Recipe:: default
#
# Copyright (c) 2016 John Kerry, All Rights Reserved.
include_recipe 'chef_handler::default'

handler_path = node['chef_handler']['handler_path']

cookbook_file "#{handler_path}/simple_slack_handler.rb" do
  source 'simple_slack_handler.rb'
  mode '0600'
  action :nothing
end.run_action(:create)

# register the new handler. This is done at runtime to avoid an unnecessary
# converge count so this remains idempotent. This can be removed when the
# chef_handler resource is idempotent
require "#{handler_path}/simple_slack_handler.rb"

# pull in the utility functions from the cheh handler cookbook
Chef::Recipe.send(:include, ::ChefHandler::Helpers)
# pull in the utility functions from this cookbook
Chef::Recipe.send(:include, ::SimpleSlackHandler::Helpers)
# unregister the handler aggressively in case it's loaded
class_name = 'Chef::Handler::SimpleSlackHandler'
unregister_handler(:exception, class_name)
_, klass = get_class(class_name)
handler = klass.send(
  :new,
  *collect_args(
    [
      node['handler']['slack']
    ]
  )
)
# register the module for exceptions
register_handler(:exception, handler)
