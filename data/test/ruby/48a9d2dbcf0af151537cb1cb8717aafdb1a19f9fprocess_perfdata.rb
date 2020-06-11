
default['pnp4nagios']['process_perfdata']['timeout'] = 15
default['pnp4nagios']['process_perfdata']['use_rrds'] = 1
default['pnp4nagios']['process_perfdata']['rrd_storage_type'] = 'SINGLE'
default['pnp4nagios']['process_perfdata']['rrd_heartbeat'] = 8460
default['pnp4nagios']['process_perfdata']['log_level'] = 0
default['pnp4nagios']['process_perfdata']['xml_enc'] = 'UTF-8'
default['pnp4nagios']['process_perfdata']['xml_update_delay'] = 0
default['pnp4nagios']['process_perfdata']['prefork'] = 1
default['pnp4nagios']['process_perfdata']['gearman_host'] = 'localhost:4730'
default['pnp4nagios']['process_perfdata']['requests_per_child'] = 10_000
default['pnp4nagios']['process_perfdata']['encryption'] = 1
default['pnp4nagios']['process_perfdata']['key'] = 'should_be_changed'
default['pnp4nagios']['process_perfdata']['key_file'] = nil
