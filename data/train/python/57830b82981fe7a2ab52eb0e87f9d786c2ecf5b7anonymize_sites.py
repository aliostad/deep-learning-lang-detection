from optparse import make_option
from django.core.management.base import LabelCommand
from logistics_project.apps.malawi.util import get_facility_supply_points, get_district_supply_points


class Command(LabelCommand):
    option_list = LabelCommand.option_list + (
        make_option('--save', action='store_true', dest='save', default=False,
                    help='actually save (as opposed to printing out changes)'),)

    def handle(self, *args, **options):
        for f in get_facility_supply_points():
            _anonymize(f, 'HC', save=options['save'])
        for d in get_district_supply_points():
            _anonymize(d, 'District', save=options['save'])

def _anonymize(supply_point, prefix, save=True):
    name = '%s %s' % (prefix, supply_point.code)
    print '%s --> %s' % (supply_point.name, name)
    supply_point.name = name
    if save:
        supply_point.save()
    if supply_point.location:
        supply_point.location.name = name
        if save:
            supply_point.location.save()
