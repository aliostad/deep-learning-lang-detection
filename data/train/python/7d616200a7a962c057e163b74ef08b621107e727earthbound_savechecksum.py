# EarthBound Save Checksum Calculator
# Written by Alchemic
# 2011 Oct 18

import sys
import array



# Check for incorrect usage.
argc = len(sys.argv)
if argc != 2:
    sys.stdout.write("Usage: ")
    sys.stdout.write("{0:s} ".format(sys.argv[0]))
    sys.stdout.write("<saveFile>\n")
    sys.exit(1)

# Open the save, read the data, close the save.
# There are six blocks of 0x500 bytes each.
# Each game save is mirrored across two blocks.
saveFile = sys.argv[1]
saveStream = open(saveFile, "rb")
saveData = array.array('B')
saveData.fromfile(saveStream, 6 * 0x500)
saveStream.close()



# Examine the data in each block.
for i in range(6):

    # Initial index of the current block, for convenience.
    saveRoot = 0x500 * i

    # 001C-1D: Additive checksum.
    addChecksum = 0
    addChecksum += saveData[saveRoot + 0x1D] << 8
    addChecksum += saveData[saveRoot + 0x1C]

    # 001E-1F: XOR checksum.
    xorChecksum = 0
    xorChecksum += saveData[saveRoot + 0x1F] << 8
    xorChecksum += saveData[saveRoot + 0x1E]

    # Calculate the additive sum from the data.
    addRealsum = 0
    for j in range(0x20, 0x500, 1):
        addRealsum += saveData[saveRoot + j]
    addRealsum &= 0xFFFF

    # Calculate the XOR sum from the data.
    xorRealsum = 0
    for j in range(0x20, 0x500, 2):
        nextWord = 0
        nextWord += saveData[saveRoot + j + 1] << 8
        nextWord += saveData[saveRoot + j]
        xorRealsum ^= nextWord

    # Print the results.
    sys.stdout.write("\n")
    sys.stdout.write("Save block: {0:d}\n".format(i))
    sys.stdout.write("Alleged add checksum: 0x{0:04X}\n".format(addChecksum))
    sys.stdout.write("Alleged XOR checksum: 0x{0:04X}\n".format(xorChecksum))
    sys.stdout.write("Calculated add checksum: 0x{0:04X}\n".format(addRealsum))
    sys.stdout.write("Calculated XOR checksum: 0x{0:04X}\n".format(xorRealsum))



# Exit.
sys.exit(0)
