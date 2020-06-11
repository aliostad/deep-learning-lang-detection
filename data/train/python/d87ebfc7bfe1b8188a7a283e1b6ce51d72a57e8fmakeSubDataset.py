#!/usr/bin/env python
import subprocess
import sys

if (len(sys.argv) != 5):
    print("Usage: ./makeSubDataset directory inputFile wantedVals saveFile")
    sys.exit(0)

dataDirname = sys.argv[1]
filename = sys.argv[2]
dataDir = "/scratch/tgelles1/summer2014/" + dataDirname + "/features/CSV_NORM/"
dataName = dataDir + filename + ".csv"
dataFile = open(dataName)

wantedVals = eval(sys.argv[3])

saveFilename = dataDir + sys.argv[4] + ".csv"

print("Loading " + dataName)
print("Saving to " + saveFilename)

saveFile = open(saveFilename, 'w')


for line in dataFile:

    vals = line.split(',')
    for i in range(len(vals)):
        if i in wantedVals:
            saveFile.write(vals[i] + ',')
    saveFile.seek(-1, 1)
    saveFile.write('\n')
