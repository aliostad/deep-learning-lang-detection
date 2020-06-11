################################################################################
# manage.py
# Runs the main operations for the server

# To make database migrations:
# - python manage.py makemigrations
# - python manage.py migrate
#
# To run server:
# - python manage.py runserver
################################################################################

#!/usr/bin/env python
import os
import sys

if __name__ == "__main__":
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "prototype.settings")

    from django.core.management import execute_from_command_line

    execute_from_command_line(sys.argv)
