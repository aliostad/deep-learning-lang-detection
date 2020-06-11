import os
import site

os.environ.setdefault('CELERY_LOADER', 'django')
# NOTE: you can also set DJANGO_SETTINGS_MODULE in your environment to override
# the default value in manage.py

# Add the app dir to the python path so we can import manage.
wsgidir = os.path.dirname(__file__)
site.addsitedir(os.path.abspath(os.path.join(wsgidir, '../')))

# manage adds /apps, /lib, and /vendor to the Python path.
import manage  # noqa

from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
