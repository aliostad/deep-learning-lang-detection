#!/bin/bash

echo "time ./take.rb < sample.txt > r.txt" 1>&2
time ./take.rb < sample.txt > r.txt

echo "time ./take.dart < sample.txt > d.txt" 1>&2
time ./take.dart < sample.txt > d.txt

echo "8g take.go && 8l -o gotake take.8 && time ./gotake < sample.txt > g.txt" 1>&2
8g take.go && 8l -o gotake take.8 && time ./gotake < sample.txt > g.txt

echo "Confirm:" 1>&2
echo "diff -u r.txt sample_output.txt" 1>&2
diff -u r.txt sample_output.txt 1>&2

echo "diff -u d.txt sample_output.txt" 1>&2
diff -u d.txt sample_output.txt 1>&2

echo "diff -u g.txt sample_output.txt" 1>&2
diff -u g.txt sample_output.txt 1>&2

