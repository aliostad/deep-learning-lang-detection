from mesh.standard import Bundle, mount
from yabl.tap.resources import *


API = Bundle('tap',
        mount(User, 'yabl.tap.controllers.user.UserController'),
        mount(Credential, 'yabl.tap.controllers.credential.CredentialController'),
        mount(Group, 'yabl.tap.controllers.group.GroupController'),
        mount(GroupPermission, 'yabl.tap.controllers.grouppermission.GroupPermissionController'),
        mount(Permission, 'yabl.tap.controllers.permission.PermissionController'),
        mount(ResourceRegistry, 'yabl.tap.controllers.resourceregistry.ResourceRegistryController'),
        mount(UserGroup, 'yabl.tap.controllers.usergroup.UserGroupController'),
)

