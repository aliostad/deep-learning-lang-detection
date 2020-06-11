import os
import logging
import logging.config
from formencode import schema as fes
from formencode import validators as fev
from formencode import foreach as fef
from formencode import variabledecode as fevd
from ConfigParser import ConfigParser

from docopt import docopt
from zmq.auth.thread import ThreadAuthenticator

from seas.zutil.mdp import MajorDomoBroker, SecureMajorDomoBroker
from seas.zutil.zutil import Key



CHUNKSIZE = 4096
log = None


class MakeKey(fev.FancyValidator):

    def _to_python(self, value, state):
        return Key(**value)


class KeySchema(fes.Schema):
    public = fev.String()
    secret = fev.String(if_missing=None)
    chained_validators = [MakeKey()]


class SettingsSchema(fes.Schema):
    pre_validators = [fevd.NestedVariables()]
    uri = fev.String()
    key = fes.Schema(
        broker=KeySchema(),
        client=KeySchema(),
        if_missing=None)


def run_mdp_broker():
    args = docopt("""Usage:
        mdp-broker [options] <config>

    Options:
        -h --help                 show this help message and exit
        -s --secure               generate (and print) client & broker keys for a secure server
    """)
    global log
    _setup_logging(args['<config>'])

    log = logging.getLogger(__name__)

    cp = ConfigParser()
    cp.read(args['<config>'])

    # Parse settings a bit
    raw = dict(
        (option, cp.get('mdp-broker', option))
        for option in cp.options('mdp-broker'))
    s = SettingsSchema().to_python(raw)

    if args['--secure']:
        broker_key = Key.generate()
        client_key = Key.generate()
        s['key'] = dict(
            broker=broker_key,
            client=client_key)
        log.info('Auto-generated keys: %s_%s_%s',
            broker_key.public, client_key.public, client_key.secret)
        log.info(' broker.public: %s', broker_key.public)
        log.info(' client.public: %s', client_key.public)
        log.info(' client.secret: %s', client_key.secret)

    if s['key']:
        log.info('Starting secure mdp-broker on %s', s['uri'])
        auth = ThreadAuthenticator()
        auth.start()
        auth.thread.authenticator.certs['*'] = {
            s['key']['client'].public: 'OK'}

        broker = SecureMajorDomoBroker(s['key']['broker'], s['uri'])
    else:
        log.info('Starting mdp-broker on %s', s['uri'])
        broker = MajorDomoBroker(s['uri'])
    try:
        broker.serve_forever()
    except:
        auth.stop()
        raise


def _setup_logging(path):
    config_file = os.path.abspath(path)
    return logging.config.fileConfig(
        config_file,
        dict(__file__=config_file, here=os.path.dirname(config_file)),
        disable_existing_loggers=False)
