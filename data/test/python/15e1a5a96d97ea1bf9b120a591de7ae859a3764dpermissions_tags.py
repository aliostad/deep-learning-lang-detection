
from __future__ import absolute_import

from django import template

from cobra.core.permissions import (
    can_create_organizations, can_create_teams, can_create_projects,
    can_remove_project, can_manage_project, can_manage_team, can_manage_org,
    can_visit_organization)

register = template.Library()

# TODO: Django doesn't seem to introspect function args correctly for filters
# so we can't just register.filter(can_add_team_member)
register.filter('can_visit_organization')(lambda a, b: can_visit_organization(a, b))
register.filter('can_create_organizations')(lambda a: can_create_organizations(a))
register.filter('can_create_teams')(lambda a, b: can_create_teams(a, b))
register.filter('can_create_projects')(lambda a, b: can_create_projects(a, b))
register.filter('can_manage_team')(lambda a, b: can_manage_team(a, b))
register.filter('can_manage_project')(lambda a, b: can_manage_project(a, b))
register.filter('can_manage_org')(lambda a, b: can_manage_org(a, b))
register.filter('can_remove_project')(lambda a, b: can_remove_project(a, b))
