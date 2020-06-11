#!/usr/bin/env python
 
"""

""" 

import sys
import pyparsing

from save_file_syntax import SaveFile
from save_file_syntax import Dictionary

import argparse
import re
from pprint import pprint


def parse_args():
    parser = argparse.ArgumentParser(description=__doc__)

    parser.add_argument('save_file', help='EU4 Save File')
    args = parser.parse_args()

    return args


def main(args):
    with open(args.save_file, 'r') as save_file:
        save_file_string = save_file.read()

    data = SaveFile.parseString(save_file_string)

    print(len(data.keys()))
    print(len(data["provinces"]))


if __name__ == '__main__':
    sys.exit(main(parse_args()))
