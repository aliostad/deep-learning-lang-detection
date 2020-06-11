# -*- coding: utf-8 -*-
"""
    inyoka.core.celery_support
    ~~~~~~~~~~~~~~~~~~~~~~~~~~

    Support module for celery.

    :copyright: 2009-2011 by the Inyoka Team, see AUTHORS for more details.
    :license: GNU GPL, see LICENSE for more details.
"""
from datetime import timedelta
from kombu.transport import get_transport_cls
from celery.loaders.base import BaseLoader
from celery.loaders.default import AttributeDict

from inyoka.context import ctx
from inyoka.core.config import TextConfigField, ListConfigField, IntegerConfigField, \
    BooleanConfigField


# celery broker settings
celery_result_backend = TextConfigField('celery.result_backend', default=u'database')
celery_result_dburi = TextConfigField('celery.result_dburi', default='sqlite:///celery.db')
celery_imports = ListConfigField('celery.imports', default=['inyoka.core.tasks'])
celery_task_serializer = TextConfigField('celery.task_serializer', default='pickle')
celery_send_task_error_emails = BooleanConfigField('celery.send_task_error_emails', default=False)
celery_eager_propagates_exceptions = BooleanConfigField('celery.eager_propagates_exceptions', default=True)
celery_track_started = BooleanConfigField('celery.track_started', default=True)

# broker settings
broker_backend = TextConfigField('broker.backend', u'sqlakombu.transport.Transport')
broker_host = TextConfigField('broker.host', 'sqlite:///kombu.db')
broker_port = IntegerConfigField('broker.port', 5672)
broker_user = TextConfigField('broker.user', u'inyoka')
broker_password = TextConfigField('broker.password', u'default')
broker_vhost = TextConfigField('broker.vhost', u'inyoka')



class CeleryLoader(BaseLoader):
    """A customized celery configuration loader that implements a bridge
    between :mod:`inyoka.core.config` and the celery configuration system.
    """

    def read_configuration(self):
        """Read the configuration from configuration file and convert values
        to celery processable values."""
        from celery.registry import tasks
        celeryd_vars = list(ctx.cfg.itersection('celeryd'))
        celery_vars = list(ctx.cfg.itersection('celery'))
        broker_vars = list(ctx.cfg.itersection('broker'))

        conv = lambda x: (x[0].upper().replace('.','_'), x[1])

        settings = map(conv, celeryd_vars + celery_vars + broker_vars)
        settings.append(('DEBUG', ctx.cfg['debug']))
        settings.append(('CELERY_ALWAYS_EAGER', ctx.cfg['testing']))

        # For backward compatibility, add the periodic task to the
        # configuration schedule instead.
        schedule = {}
        for task in tasks.periodic().itervalues():
            schedule[task.name] = {
                'task': task.name,
                'schedule': task.run_every,
                'args': (),
                'kwargs': {},
                'options': task.options or {},
                'relative': task.relative}
        settings.append(('CELERYBEAT_SCHEDULE', schedule))

        self.configured = True

        return AttributeDict(dict(settings))
