#
# Cookbook Name:: users
# Recipe:: manage_groups
#
# Copyright (C) 2013 Ptah Dunbar
#
# All rights reserved - Do Not Redistribute
#

if node[:users][:manage_groups]
	node[:users][:manage_groups].each do |g|
		next unless g["name"]

		manage = true unless g['action'] and 'delete' == g['action']

		if g['members']
			g['members'].split(' ').each do |member|
				group g["name"] do
					members member
					system g['system'] if g['system']
					append true
					action :create if manage
					action :remove if !manage
				end
			end
		else
			group g["name"] do
				system g['system'] if g['system']
				action :create if manage
				action :remove if !manage
			end
		end
	end
end