''' Command line tool to manage (create/delete) Elastic repository. '''
from django.core.management.base import BaseCommand, CommandError
from elastic.management.snapshot import Snapshot


class Command(BaseCommand):
    help = "Create or delete a repository."

    def add_arguments(self, parser):
        parser.add_argument('repo',
                            type=str,
                            metavar="REPOSITORY_NAME",
                            help='Repository name.')
        parser.add_argument('--dir',
                            dest='dir',
                            metavar="/path_to_repository/",
                            help='Directory to store repository.')
        parser.add_argument('--delete',
                            dest='delete',
                            action='store_true',
                            help='Delete repository.')

    def handle(self, *args, **options):
        if options['delete']:
            Snapshot.delete_repository(options['repo'])
        else:
            if not options['dir']:
                raise CommandError("the following arguments are required: dir")
            Snapshot.create_repository(options['repo'], options['dir'])
