from jetee.base.process import AbstractProcess


class CeleryWorkerProcess(AbstractProcess):
    """
    Celery worker process
    """
    initial_command = u'celery worker'
    env_variables = {u'C_FORCE_ROOT': u'True'}

    def __init__(self, app=None, queues=None, broker=None, concurrency=4, beat=False):
        self.app = app
        self.queues = queues
        self.broker = broker
        self.concurrency = concurrency
        self.beat = beat

    def get_name(self):
        return u'celery_tasks'

    def get_command(self):
        command = self.initial_command
        if self.app:
            command += u' --app=%s' % self.app
        if self.queues:
            command += u' --queues=' + u','.join(self.queues)
        if self.broker:
            command += u' --broker=%s' % self.broker
        if self.concurrency:
            command += u' --concurrency=%i' % int(self.concurrency)
        if self.beat:
            command += u' --beat'
        return command