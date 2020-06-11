#
# Cookbook Name:: sensu-manage
# Attributes:: default
#
# Copyright (C) 2015 Exequiel Pierotto
#
# All rights reserved - Do Not Redistribute
#

# Windows config
default['sensu-manage']['windows']['admin_user'] = "Administrator"
default['sensu-manage']['windows']['directory'] = 'C:/etc/sensu'
default['sensu-manage']['windows']['log_directory'] = 'C:/var/log/sensu'
default['sensu-manage']['windows']['dism_source'] = nil
default['sensu-manage']['windows']['plugins']['dir'] = "C:/opt/sensu/plugins"
default['sensu-manage']['windows']['package']['source'] = "http://repos.sensuapp.org/msi/sensu-0.12.3-1.msi"
default['sensu-manage']['windows']['package']['checksum'] = "1df8fccb861adea9723f49392a393ab6a557e70c3515f7b45f3faf689f3e2b53"

# Linux config
default['sensu-manage']['linux']['admin_user'] = "root"
default['sensu-manage']['linux']['user'] = "sensu"
default['sensu-manage']['linux']['group'] = "sensu"
default['sensu-manage']['linux']['directory'] = "/etc/sensu"
default['sensu-manage']['linux']['log_directory'] = "/var/log/sensu"
default['sensu-manage']['linux']['log_level'] = "info"
default['sensu-manage']['linux']['service_max_wait'] = 10
default['sensu-manage']['linux']['use_embedded_ruby'] = true
default['sensu-manage']['linux']['plugins']['dir'] = "/opt/sensu/plugins"
default['sensu-manage']['linux']['package']['source'] = "http://repos.sensuapp.org/yum/el/6/x86_64/sensu-0.16.0-1.x86_64.rpm"
default['sensu-manage']['linux']['package']['version'] = "0.16.0"
default['sensu-manage']['linux']['package']['checksum'] = "1df8fccb861adea9723f49392a393ab6a557e70c3515f7b45f3faf689f3e2b53"
default['sensu-manage']['linux']['package']['options'] = ""

# SSL config data_bag
default['sensu-manage']['ssl']['data_bag'] = "sensu"
default['sensu-manage']['ssl']['ssl_item'] = "ssl"

# Rabbitmq config
default['sensu-manage']['rabbitmq']['host'] = "rabbitmq.service.consul"
default['sensu-manage']['rabbitmq']['port'] = 5671
default['sensu-manage']['rabbitmq']['vhost'] = "/sensu"
default['sensu-manage']['rabbitmq']['user'] = "sensu"
default['sensu-manage']['rabbitmq']['password'] = "sensu"


# Checks data_bags				data_bag | items | config
default['sensu-manage']['checks']['data_bags'] = {
						"sensu_checks" => {
							"check-consul_service" => { 
								"command" => "nc -zv 10.0.0.10 4000",
								"interval" => 10, 
								"type" => "metric"
								#"dependencies" => ["ldap.example.com/ldap"]
							 }
							#"test" => {}
						}
}

