import os
import sys

try:
    os.chdir(os.path.dirname(__file__))
except WindowsError:
    pass

print "*** Checking for DB Migrations... ***"
os.system('python manage.py makemigrations')

print "\n*** Syncing DB Entries... ***"
os.system('python manage.py syncdb')

print "\n*** Collecting static... please take off your wool sweaters for safety ***"
if '--clear' in sys.argv:
    os.system('python manage.py collectstatic --clear --noinput')
else:
    os.system('python manage.py collectstatic --noinput')

print "\n*** Finally... running the server. Have fun! ***"
os.system('python manage.py runserver')
