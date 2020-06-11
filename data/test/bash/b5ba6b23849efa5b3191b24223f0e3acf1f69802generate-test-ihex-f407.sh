#!/bin/sh

# generate a iHex file suitable for the unit test on a stm32f407

# generate a chunk of data in the middle of sector 5
# generate a chunk of data across the end of sector 5 and the beginning of sector 6
# generate a chunk of data in the middle of sector 6

# sector 5: 0x08020000 -> 0x0803FFFF
# sector 6: 0x08040000 -> 0x0805FFFF

srec_cat \
    -generate 0x08030460 0x08030500 -repeat-string "unit test: chunk 1 pattern" \
    -generate 0x0803FF83 0x08040011 -repeat-string "unit test: chunk 2 pattern" \
    -generate 0x08040500 0x08040507 -repeat-string "unit test: chink 3 pattern" \
    -o test-f407.ihex -intel

