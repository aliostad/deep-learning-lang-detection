#!/usr/bin/python2
# -*- coding: utf-8 -*-

import sys

FILE_SAVE_OUT = open("data/OpenFST_raw.txt", "w")

COUNTER = 2
for line in sys.stdin:
    line = line.rstrip()
    line = line.decode('utf-8')
    LEN_WORD = len(line)
    FILE_SAVE_OUT.write("0 " + str(COUNTER) + " " + line[0].encode('utf-8') + " " + line[0].encode('utf-8') + "\n")
    if LEN_WORD > 2:
        for i in range(1,LEN_WORD-1):
            FILE_SAVE_OUT.write(str(COUNTER) + " ")
            COUNTER+=1
            FILE_SAVE_OUT.write(str(COUNTER) + " " + line[i].encode('utf-8') + " " + line[i].encode('utf-8') + "\n")
        FILE_SAVE_OUT.write(str(COUNTER) + " ")
        FILE_SAVE_OUT.write("1 " + line[-1].encode('utf-8') + " " + line[-1].encode('utf-8') + "\n")
        COUNTER+=1
    else:
        FILE_SAVE_OUT.write("2 1 " + line[1].encode('utf-8') + " " + line[1].encode('utf-8') + "\n")

FILE_SAVE_OUT.write("1\n")
FILE_SAVE_OUT.close()
