#!/usr/bin/env python

import os
import sys

from lib.CabieServer import CabieServer

cs = CabieServer()

dir = os.getcwd();

def testcommands(commands):

    for cmd in commands:

        for line in cs.broker(cmd):

            print line

        for help in cs.broker('help', cmd):

            print help

    for entry in cs.broker('commands'):

        print entry

if __name__ == "__main__":

    if __file__ == './cabie.py':

        cs.registerserver()

        testcommands(cs.commands)

        cs.unregisterserver()

    else:

        print "tests must be executed from the dir where unittest.py resides"
        sys.exit(1)
