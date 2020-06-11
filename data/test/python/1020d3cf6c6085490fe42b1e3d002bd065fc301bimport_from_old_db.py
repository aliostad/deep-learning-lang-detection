from django.core.management.base import BaseCommand
from scraper.models import Incident, IncidentType, \
    Dispatch, Vehicle, VehicleType
import csv
import datetime
import re
from pytz import timezone


class Command(BaseCommand):
    help = 'Imports data from legacy database csv'

    def add_arguments(self, parser):
        parser.add_argument('incident_file', help="incident csv file")
        parser.add_argument('dispatch_file', help="dispatch csv file")

    def handle(self, *args, **options):
        dispatch_path = options['dispatch_file']
        incident_path = options['incident_file']

        date_format = '%Y-%m-%d %H:%M:%S'
        incident_models = []
        local_tz = timezone('America/Los_Angeles')

        count = 0
        print 'processing incident'
        with open(incident_path, 'rb') as csvfile:
            incident_reader = csv.reader(csvfile, delimiter=',', quotechar='|')
            for row in incident_reader:
                inc = Incident()
                inc.incident_id = row[0]
                inc.start = local_tz.localize(datetime.datetime.strptime(
                    row[1], date_format))
                try:
                    inc.end = local_tz.localize(datetime.datetime.strptime(
                        row[2], date_format))
                except Exception:
                    pass
                inc.location_text = row[3]
                incident_type, created = IncidentType.objects.get_or_create(
                    type_name=row[4])
                inc.type = incident_type
                inc.level = row[5]
                incident_models.append(inc)
                count += 1
                if count % 10000 == 0:
                    print 'inserting Incidents'
                    Incident.objects.bulk_create(incident_models)
                    incident_models = []
                    print 'processing incident'

        dispatch_models = []
        print 'processing dispatch'
        with open(dispatch_path, 'rb') as csvfile:
            dispatch_reader = csv.reader(csvfile, delimiter=',', quotechar='|')
            for row in dispatch_reader:

                dispatch = Dispatch()
                dispatch.incident_id = Incident.objects.get(incident_id=row[1])
                dispatch.timestamp = local_tz.localize(
                    datetime.datetime.strptime(row[2], date_format)
                )

                p = re.compile("([A-Za-z]+)")
                match = p.search(row[0])
                try:
                    vehicle_type_string = match.group()
                except AttributeError:
                    vehicle_type_string = "UNKNOWN"
                vehic_type, created = VehicleType.objects.get_or_create(
                    name=vehicle_type_string)
                vehicle, created = \
                    Vehicle.objects.get_or_create(name=row[0],
                                                  defaults={'type': vehic_type}
                                                  )

                dispatch.vehicle_id = vehicle
                dispatch_models.append(dispatch)
                count += 1
                if count % 10000 == 0:
                    print 'inserting Dispatches'
                    Dispatch.objects.bulk_create(dispatch_models)
                    dispatch_models = []
                    print 'processing dispatch'
