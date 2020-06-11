from django.core import management
from django.utils.translation import ugettext as _

from cobra.core.loading import get_model

Repository = get_model('svnkit', 'Repository')


class Command(management.BaseCommand):
    help = _('Get repository changes')
    args = _('<repository repository ...>')
    
    def handle(self, *args, **options):
        if args:
            try:
                rlist = map(
                    lambda r: Repository.objects.get(label=r), args)
            except Repository.DoesNotExist, error:
                raise management.CommandError(error)
        else:
            rlist = Repository.objects.all()
        
        for r in rlist:
            print _('Syncing %(label)s...') % {'label': r.label}
            r.sync()
