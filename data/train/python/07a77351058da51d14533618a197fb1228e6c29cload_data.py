#!/usr/bin/python

"""Invocation:  scripts/load_data

Loads the default configuration of data into makahiki.

Note: when the system is stable, could simply run python manage.py loaddata fixtures/*
"""

import os
import sys

sys.path.append(os.path.dirname(os.path.realpath(__file__)) + os.sep + os.pardir + os.sep)
from apps.utils import script_utils


def main():
    """main function."""

    manage_dir = script_utils.manage_py_dir()
    manage_py = script_utils.manage_py_command()
    fixture_path = manage_dir + "fixtures"

    os.system("python " + manage_py + " loaddata %s" % os.path.join(fixture_path, "base_*.json"))
    os.system("python " + manage_py + " loaddata %s" % os.path.join(fixture_path, "demo_*.json"))
    os.system("python " + manage_py + " loaddata %s" % os.path.join(fixture_path, "test_*.json"))


if __name__ == '__main__':
    main()
