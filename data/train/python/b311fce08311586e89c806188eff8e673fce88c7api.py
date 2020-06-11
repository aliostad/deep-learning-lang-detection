from rest_framework import routers

from etat.departments import api as departments_api
from etat.members import api as members_api


api = routers.DefaultRouter()

api.register(r'departments', departments_api.DepartmentViewSet)
api.register(r'department_types', departments_api.DepartmentTypeViewSet)

api.register(r'members', members_api.MemberViewSet)
api.register(r'role_types', members_api.RoleTypeViewSet)
api.register(r'roles', members_api.RoleViewSet)
api.register(r'addresses', members_api.AddressViewSet)
api.register(r'reachabilities', members_api.ReachabilityViewSet)
