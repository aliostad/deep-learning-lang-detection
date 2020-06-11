# -*- coding: utf-8 -*-

# Web2py plugin to easy create user groups and manage their members.
# Navigate to <app>/plugin_manage_groups/group/<group_name> to (create group and) manage group members.

# Following cofiguration values are defaults.
# You can change them in db.py or other model (alphabetically after db.py, but before this model).
# Example: to avoid creating of the admin group, set: plugins.manage_groups.first_admin=False

def _():
    from gluon.tools import PluginManager
    plugins = PluginManager('manage_groups',
            first_admin=True,                # if admin group will be auto-created and the 1st user made admin member
            admin_group='admin',      # name of the admin group
            create=True,                           # if new groups can be created when navigating to plugin_manage_groups/group/<group_name>
            limit_dense_rows=11,       # if less users/members, it will output each user on separate line
            limit_hide_users=61,         # if so many or more users, they will be not listed and are selectable with the html input field
            # do not configure the rest
            table_user=auth.table_user(),
            table_group = auth.table_group(),
            table_membership = auth.table_membership()
            )

    if plugins.manage_groups.first_admin and plugins.manage_groups.admin_group and "auth" in globals() and auth.user_id:
        if not auth.id_group(plugins.manage_groups.admin_group):
            auth.add_membership(auth.add_group(plugins.manage_groups.admin_group), auth.user_id)
            redirect(URL(args=request.args))

plugin_manage_groups = _()
