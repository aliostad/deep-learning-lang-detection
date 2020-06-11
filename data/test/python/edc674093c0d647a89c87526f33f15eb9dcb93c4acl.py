from models import *
from controllers.scan_controller import ScanController
from controllers.audit_controller import AuditController
from controllers.access_controller import AccessController
from rbac.acl import Registry
from rbac.proxy import RegistryProxy
from rbac.context import IdentityContext, PermissionDenied

# create a access control list
acl = RegistryProxy(Registry())
identity = IdentityContext(acl, lambda: User.current_user().get_roles())

# registry roles and resources
acl.add_role("staff")
acl.add_role("audit")
acl.add_role("admin")
acl.add_resource(ScanController)
acl.add_resource(AuditController)
acl.add_resource(AccessController)

# add rules
acl.allow("staff", "use", ScanController)
acl.allow("audit", "use", AuditController)
acl.allow("admin", "use", AccessController)