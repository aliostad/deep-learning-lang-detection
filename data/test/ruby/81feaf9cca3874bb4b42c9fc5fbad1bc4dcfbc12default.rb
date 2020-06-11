#
# Cookbook Name:: berkshelf-api
# Attribute:: default
#
# Copyright (C) 2013-2014 Jamie Winsor
#
#
# Customized by maniac for centos system

default[:berkshelf_api][:repo]           = "berkshelf/berkshelf-api"
default[:berkshelf_api][:release]        = "v#{Berkshelf::API::Chef.cookbook_version(run_context)}"
default[:berkshelf_api][:owner]          = "berkshelf-api"
default[:berkshelf_api][:group]          = "berkshelf-api"
default[:berkshelf_api][:home]		= "/opt/berkshelf-api"
default[:berkshelf_api][:deploy_path]    = "#{node[:berkshelf_api][:home]}/#{node[:berkshelf_api][:release]}"
default[:berkshelf_api][:release_symlink] = "#{node[:berkshelf_api][:home]}/current"
default[:berkshelf_api][:port]           = 26200
default[:berkshelf_api][:host]           = "127.0.0.1"
default[:berkshelf_api][:config]    = "#{node[:berkshelf_api][:home]}/config.json"
