# -*- coding: utf-8 -*-

from django.core.management.base import BaseCommand, CommandError

from porchlightapi.models import Repository, ValueDataPoint

class Command(BaseCommand):
    args = '<repository_url repository_url ...>'
    help = 'Fetch value data points for the given repositories'

    def handle(self, *args, **options):

        repositories = []
        if len(args) > 0:
            for repository_url in args:
                try:
                    repositories.append(Repository.objects.get(url=repository_url))
                except Repository.DoesNotExist:
                    raise CommandError('Repository {} is not in Porchlight'.format(repository_url))

        else:
            repositories = Repository.objects.all()

        for repository in repositories:
            datapoint = ValueDataPoint.objects.create_datapoint(repository)

            self.stdout.write('Got datapoint for {}: {}'.format(repository.url, datapoint.value))


