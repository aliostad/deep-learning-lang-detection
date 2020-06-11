
#proportions: es 5, de 2, id 1, pt 1, fr 1, nl 1
#
# constraints are es size and id size.
#
#  lines  words   bytes
#  28738  209877 1617508 de-wikipedia.txt
#  21486  178768 1210181 es-wikipedia.txt
#  32451  252688 1761851 fr-wikipedia.txt
#   6549   40885  323993 id-wikipedia.txt
#  12316   87701  606403 nl-wikipedia.txt
#  16571  117541  876191 pt-wikipedia.txt
# 118111  887460 6396127 total

CHUNK=$(( `wc -c < es-wikipedia.txt` / 5))

cat es-wikipedia.txt > combined.txt
head -c $(($CHUNK * 2)) de-wikipedia.txt >> combined.txt
head -c $(($CHUNK * 1)) id-wikipedia.txt >> combined.txt
head -c $(($CHUNK * 1)) pt-wikipedia.txt >> combined.txt
head -c $(($CHUNK * 1)) fr-wikipedia.txt >> combined.txt
head -c $(($CHUNK * 1)) nl-wikipedia.txt >> combined.txt

#don't worry about the dutch.
