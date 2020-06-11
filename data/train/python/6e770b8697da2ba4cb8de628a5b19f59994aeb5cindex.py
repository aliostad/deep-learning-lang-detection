import itertools
import os
import re

from midx.brokers import get_broker
from midx.scanner import Scanner, parse_path
from midx.sequence import Sequence


class Index(object):

    def __init__(self, url):
        self.broker = get_broker(url)

    def scan(self, root):
        root = os.path.abspath(root)
        key = lambda s: (s.prefix, s.postfix)
        for key, sequences in itertools.groupby(Scanner().walk(root), key):
            self.broker.add_sequences(sequences, replace=True)

    def glob(self, prefix=None, postfix=None):
        return self.broker.iter_glob(prefix, postfix)

    def add_path(self, path):
        parsed = parse_path(path)
        if not parsed:
            return
        prefix, postfix, num, padding = parsed
        seq = Sequence(prefix, postfix, num, num, padding)
        self.broker.add_sequences([seq], replace=False)


