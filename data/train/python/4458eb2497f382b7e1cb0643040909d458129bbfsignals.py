from django import dispatch
modify_ftpgroup_gid_done = dispatch.Signal(providing_args=['obj'])

modify_ftpgroup_groupname_done = dispatch.Signal(providing_args=['obj'])

delete_ftpgroup_done = dispatch.Signal(providing_args=['obj'])


create_ftpquotalimits_done = dispatch.Signal(providing_args=['obj'])

modify_ftpquotalimits_quotatype_done = dispatch.Signal(providing_args=['obj'])

delete_ftpquotalimits_done = dispatch.Signal(providing_args=['obj'])


modify_ftpuser_username_done = dispatch.Signal(providing_args=['obj'])

delete_ftpuser_done = dispatch.Signal(providing_args=['obj'])