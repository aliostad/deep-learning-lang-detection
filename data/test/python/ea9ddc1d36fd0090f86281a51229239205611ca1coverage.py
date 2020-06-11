#!/usr/bin/python

"""Invocation:  scripts/coverage.py

Runs the tests and computes their coverage. An HTML coverage report is
 generated in htmlcov/."""

import os
import sys
sys.path.append(os.path.dirname(os.path.realpath(__file__)) + os.sep + os.pardir + os.sep)
from apps.utils import script_utils


def main(argv):
    """main"""

    verbose = script_utils.has_verbose_flag(argv)

    # get full path to the directory with manage.py in it.
    manage_dir = script_utils.manage_py_dir()
    manage_py = script_utils.manage_py_command()

    command = "coverage erase"
    if verbose:
        print command
    os.system(command)
    command = "python " + manage_py + " clean_pyc"
    if verbose:
        print command
    os.system(command)
    command = "coverage run --source=" + manage_dir + "apps " + manage_py + " test"
    if verbose:
        print command
    os.system(command)
    command = "coverage html"
    if verbose:
        print command
    os.system(command)

if __name__ == '__main__':
    main(sys.argv[1:])
