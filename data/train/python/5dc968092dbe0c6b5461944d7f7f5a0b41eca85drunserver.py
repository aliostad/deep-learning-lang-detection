#!/usr/bin/env python

import os

try:
    os.chdir(os.path.dirname(__file__))
except:
    pass

print "*** Checking for DB Migrations... ***"
os.system('python manage.py makemigrations')

print "\n*** Syncing DB Entries... ***"
os.system('python manage.py syncdb')

print "\n*** Checking pip status... ***"
os.system('pip install -r requirements.txt')

#print "\n*** Collecting static... ***"
#if '--clear' in sys.argv:
#    os.system('python manage.py collectstatic --clear --noinput')
#else:
#    os.system('python manage.py collectstatic --noinput')

print "\n*** Finally... running the server. Have fun! ***"
os.system('python manage.py runserver')
