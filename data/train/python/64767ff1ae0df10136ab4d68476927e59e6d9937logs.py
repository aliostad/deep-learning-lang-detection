__author__ = 'zhaolei'
logs_information = [
    ['create_controller_action', 'Common Manage', 'add', 'dsadsadsa', 'true'],
    ['controllers_instance_reboot', 'Instance Manage', 'edit',
     'user %(user)s %(create_at)s reboot instance', 'true'],
    ['controllers_instance_pause', 'Instance Manage', 'edit',
     'user %(user)s %(create_at)s paused instance', 'false'],
    ['controllers_instance_unpause', 'Instance Manage', 'edit',
     'user %(user)s %(create_at)s unpaused instance', 'false'],
    ['controllers_instance_stop', 'Instance Manage', 'edit',
     'user %(user)s %(create_at)s stopped instance', 'true'],
    ['controllers_instance_unstop', 'Instance Manage', 'edit',
     'user %(user)s %(create_at)s unstopped instance', 'false'],
    ['change_pwd', 'Instance Manage', 'edit',
     'user %(user)s %(create_at)s changed password of instance', 'false'],
    ['controllers_update_instance', 'Instance Manage', 'edit',
     'user %(user)s %(create_at)s updated instance', 'false'],
    ['create_snapshot', 'Instance Manage', 'add',
     'user %(user)s %(create_at)s created snapshot', 'false'],
    ['restore_instance_data', 'Instance Manage', 'edit',
     'user %(user)s %(create_at)s restored instance data', 'false'],
    ['set_snapshot_public', 'Instance Manage', 'edit',
     'user %(user)s %(create_at)s set snapshot public', 'false'],
    # instance classify
    #    ['instance_flavor_update','Instance Manage','edit',get_text('user %(user)s %(create_at)s updated instance flavor'),'false'],

    ['select_controller_instance_classify', 'Instance Manage', 'add',
     'user %(user)s %(create_at)s create instance classify', 'false'],
    ['controller_instance_classify_update_action', 'Instance Manage', 'edit',
     'user %(user)sr %(create_at)s update instance classify', 'false'],
    ['controller_instance_classify_delete_action', 'Instance Manage', 'del',
     'user %(user)s %(create_at)s deleted instance classify', 'false'],
    ['controller_instance_classify_new_action', 'Instance Manage', 'add',
     'user %(user)s %(create_at)s created instance classify', 'false'],


]