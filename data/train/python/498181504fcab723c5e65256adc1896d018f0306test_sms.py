from django.core.management.base import BaseCommand, CommandError

from dispatches.utils import send_msg
from dispatches.models import Dispatch



class Command(BaseCommand):
    help = 'Test twilio utils'
    
    
    def handle(self, *args, **options):
        # '2012049708'
        
        dispatch = Dispatch.objects.get(tf='2012049774') 
        send_msg("9187285597",None,dispatch)
        
        dispatch = Dispatch.objects.get(tf='2012049708') 
        send_msg("9187285597",None,dispatch)
        
        # send_msg("9187285597","howdy",None)
        
