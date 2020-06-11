#!/bin/bash

# This script should take exactly one argument, a file.  It should
# invoke emacs on the file if the file has a txt extension.  It should
# invoke firefox on the file if the file has a html extension.  It
# should invoke evince on the file if the file has a pdf extension.
# It should exit reporting error if the file has no extension or if it
# has some other extension.  The script should handle arguments which
# have multiple '.' characters.  For example, the extension for file
# a.b.txt is 'txt'.
