default['manage-mysql-db']['mysql']['db'] = 'my_app_db'
default['manage-mysql-db']['mysql']['hostname'] = '127.0.0.1'
default['manage-mysql-db']['mysql']['bind_address'] = '0.0.0.0'
default['manage-mysql-db']['mysql']['port'] = '3306'
default['manage-mysql-db']['mysql']['user'] = 'root'
default['manage-mysql-db']['mysql']['password'] = 'mysql'
default['manage-mysql-db']['mysql']['script_dir_name'] = 'mysql_scripts'
default['manage-mysql-db']['mysql']['cache_script_path'] = Chef::Config[:file_cache_path] + '/' + default['manage-mysql-db']['mysql']['script_dir_name']
default['manage-mysql-db']['mysql']['scripts'] = ['V001__schema.sql', 'V002__data.sql']

default['flyway']['conf'] = {
	url: 'jdbc:mysql://' + default['manage-mysql-db']['mysql']['hostname'] + '/' + default['manage-mysql-db']['mysql']['db'],
	user: default['manage-mysql-db']['mysql']['user'],
	password: default['manage-mysql-db']['mysql']['password'],
	locations: 'filesystem:' + default['manage-mysql-db']['mysql']['cache_script_path']
}