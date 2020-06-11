from avx.controller.Controller import *
from argparse import ArgumentParser

if __name__ == '__main__':
    parser = ArgumentParser()
    parser.add_argument("-c",
                        help="Specify the controller ID to connect to",
                        metavar="CONTROLLERID",
                        default="")
    args = parser.parse_args()

    c = Controller.fromPyro(args.c)

    remoteVersion = c.getVersion()

    if remoteVersion != Controller.version:
        raise VersionMismatchError(remoteVersion, Controller.version)
    print "Controller c available."
