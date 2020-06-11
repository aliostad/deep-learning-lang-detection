class ACObject(object): # Access Control Object
    def __init__(self, name):
        self.name = name
        self.label = name.replace('_', ' ').capitalize()
        self.description = self.label + ' ' + self.__class__.__name__.capitalize()
    def __str__(self):
        return "<%s: %s>" % (self.__class__.__name__, self.label)
    def __repr__(self):
        return "<%s: %s>" % (self.__class__.__name__, self.label)

class Permission(ACObject): pass

admin_application = Permission('admin')
access_business = Permission('access_business')
manage_own_profile = Permission('manage_own_profile')
manage_invoices = Permission('manage_invoices')
manage_biz_profile = Permission('manage_biz_profile')
apply_membership = Permission('apply_membership')
view_own_invoices = Permission('view_own_invoices')
search_biz = Permission('search_biz')
approve_membership = Permission('approve_membership')
invite_member = Permission('invite_member')
activate_member = Permission('activate_member')
manage_team = Permission('manage_team')

class Role(ACObject): pass

admin = Role('admin')
admin.permissions = [admin_application]

registered = Role("registered")
registered.permissions = [
    apply_membership,
    ]

member = Role("member")
member.permissions = [
    access_business,
    manage_own_profile,
    search_biz,
    view_own_invoices,
    #access_own_info,
    ]

host = Role("host")
host.permissions = [
    approve_membership,
    invite_member,
    manage_biz_profile,
    activate_member,
    manage_invoices,
    manage_team,
    ]

director = Role("director")
director.permissions = [
    approve_membership,
    invite_member,
    manage_biz_profile,
    activate_member,
    manage_invoices,
    manage_team,
    ]


ordered_roles = ("admin", "director", "host", "member")
all_roles = dict((v.name, v) for v in globals().values() if isinstance(v, Role))
all_permissions = dict((v.name, v) for v in globals().values() if isinstance(v, Permission))

#TODO : Add additional roles like accountant, event manager when they are
#       defined above
team_roles =  [host, director]

