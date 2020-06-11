def initialize(context):
    import users_editor
    from eea.userseditor import userdetails
    constructors = (
        ('manage_addUsersEditor_html', users_editor.manage_addUsersEditor_html),
        ('manage_addUsersEditor', users_editor.manage_addUsersEditor),
    )
    context.registerClass(users_editor.UsersEditor, constructors=constructors)

    context.registerClass(userdetails.UserDetails, constructors=(
        ('manage_add_userdetails_html',
         userdetails.manage_add_userdetails_html),
        ('manage_add_userdetails', userdetails.manage_add_userdetails),
    ))