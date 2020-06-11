# -*- coding: utf-8 -*-

def index():
    if not plugins.manage_groups.admin_group:
        return T('use syntax: plugin_manage_groups/group/<groupname> --or-- set plugins.manage_groups.admin_group in model db.py (or other one - see model/plugin_manage_groups)')
    redirect(URL('group', args=plugins.manage_groups.admin_group))

@auth.requires_membership(plugins.manage_groups.admin_group)
def group():
    if 1<=len(request.args)<=2:   # 2 reserved for description
        hint = None
        groups = db(plugins.manage_groups.table_group.role==request.args[0]).select()
        if groups:
            group_id = groups.first().id
        elif plugins.manage_groups.create:
            group_id = plugins.manage_groups.table_group.insert(role=request.args[0])
            db.commit()
        else:
            return T('creating of new groups is not enabled - to change this setting see model/plugin_manage_groups')

        groups = db(plugins.manage_groups.table_group).select(orderby=plugins.manage_groups.table_group.role.lower())
        member_counts = {}
        count = plugins.manage_groups.table_membership.group_id.count()
        member_counts_db = db(plugins.manage_groups.table_membership).select(
                plugins.manage_groups.table_membership.group_id, count,
                orderby=plugins.manage_groups.table_membership.group_id,
                groupby=plugins.manage_groups.table_membership.group_id
                )
        for membership in member_counts_db:
            member_counts[membership.auth_membership.group_id] = membership[count]

        order_users = plugins.manage_groups.table_user.username.lower() if auth.settings.use_username else plugins.manage_groups.table_user.email.lower()
        users = db(plugins.manage_groups.table_user).select(orderby=order_users, limitby=(0, plugins.manage_groups.limit_hide_users))
        member_fields = [plugins.manage_groups.table_user.username, plugins.manage_groups.table_user.email] if auth.settings.use_username else [plugins.manage_groups.table_user.email]
        members = db((plugins.manage_groups.table_membership.group_id==group_id) & (plugins.manage_groups.table_user.id==plugins.manage_groups.table_membership.user_id)).select(
                plugins.manage_groups.table_user.id, *member_fields, orderby=order_users)
        if len(users)>=plugins.manage_groups.limit_hide_users:
            large = SQLFORM.factory(
                    Field('candidate', label=(T("User") if auth.settings.use_username else T("E-mail")),
                            comment=(T("enter username or email (exact or starting characters)") if auth.settings.use_username
                                else T("enter email or its starting characters"))),
                    submit_button=T("Find and add the user"))
            if large.process(keepvalues=True).accepted:
                if large.vars.candidate:
                    pattern = large.vars.candidate.lower()
                    new_member = db(plugins.manage_groups.table_user.email.lower()==pattern).select().first() if ('@' in pattern) else None
                    if not new_member:
                        if auth.settings.use_username:
                            new_member = db(plugins.manage_groups.table_user.username.lower()==pattern).select().first()
                    if not new_member:
                        candidates = db(plugins.manage_groups.table_user.email.lower().like(pattern+'%')).select()
                        if auth.settings.use_username:
                            candidates = candidates | db(plugins.manage_groups.table_user.username.lower().like(pattern+'%')).select()
                        first_candidate = candidates.first()
                        if first_candidate:
                            if len(candidates)==1:
                                new_member = first_candidate
                            else:
                                response.flash = T("Ambiguous candidate user, choose one from the hint ('Did you mean?').")
                                hint = candidates
                        else:
                            session.flash = T("Cannot find the user.")
                    if new_member:
                        new_info = new_member.username if auth.settings.use_username else new_member.email
                        if __addms(group_id, new_member.id):
                            session.flash = T("User %s was added.") % new_info
                        else:
                            session.flash = T("User %s is already a member.") % new_info
                if not hint:
                    redirect(URL(args=request.args)) # re-read
            cnt_candidates = 'many' # must be non empty
        else:
            large = None
            cnt_candidates = 0
            for user in users:
                user_id = user.id
                for member in members:
                    if member.id==user_id:
                        user.is_member = True
                        break
                else:
                    user.is_member = False
                    cnt_candidates += 1

        return {'groups': groups, 'member_counts': member_counts, 'users': users, 'members': members,
                'large': large, 'limit_dense': plugins.manage_groups.limit_dense_rows, 'cnt_candidates': cnt_candidates,
                'group_id': group_id, 'manage_me': request.args[0]!=plugins.manage_groups.admin_group,
                'hint': hint}
    else:
        return T('use syntax: plugin_manage_groups/group/<groupname>')

@auth.requires_membership(plugins.manage_groups.admin_group)
def delgroup():
    if len(request.args)==1:
        del plugins.manage_groups.table_group[request.args[0]]
        db(plugins.manage_groups.table_membership.group_id==request.args[0]).delete()  # called for empty group only - but be sure - maybe somebody has changed this?
    if plugins.manage_groups.admin_group:
        redirect(URL('group', args=plugins.manage_groups.admin_group))
    else:
        redirect(URL('default', 'index'))

@auth.requires_membership(plugins.manage_groups.admin_group)
def addms():
    if len(request.args)==2:
        __addms(request.args[0], request.args[1])
    __reload_group(request.args[0])

def __addms(group_id, user_id):
    if not db((plugins.manage_groups.table_membership.group_id==group_id) & (plugins.manage_groups.table_membership.user_id==user_id)).select():
        plugins.manage_groups.table_membership.insert(group_id=group_id, user_id=user_id)
        return True
    else:
        return False

@auth.requires_membership(plugins.manage_groups.admin_group)
def delms():
    if len(request.args)==2:
        db((plugins.manage_groups.table_membership.group_id==request.args[0]) & (plugins.manage_groups.table_membership.user_id==request.args[1])).delete()
    __reload_group(request.args[0])

def __reload_group(group_id):
    redirect(URL('group', args=db(plugins.manage_groups.table_group.id==group_id).select(plugins.manage_groups.table_group.role).first().role))