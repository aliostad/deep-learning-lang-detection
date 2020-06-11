#! /bin/bash

PREFIX=hbase-dump-2015-10-01-2015-12-01-aman-hbase/hbase-dump-2015-10-01-2015-12-01-aman-hbase-crf-

cut -f 2 ${PREFIX}name-ethnic-sample.txt > ${PREFIX}name-ethnic-sample.jsonl

jq '{B_ethnic: .B_ethnic}' -c < ${PREFIX}name-ethnic-sample.jsonl | fgrep -v ':null' > ${PREFIX}B_ethnic-sample.jsonl
jq '{I_ethnic: .I_ethnic}' -c < ${PREFIX}name-ethnic-sample.jsonl | fgrep -v ':null' > ${PREFIX}I_ethnic-sample.jsonl
jq '{B_workingname: .B_workingname}' -c < ${PREFIX}name-ethnic-sample.jsonl | fgrep -v ':null' > ${PREFIX}B_workingname-sample.jsonl
jq '{I_workingname: .I_workingname}' -c < ${PREFIX}name-ethnic-sample.jsonl | fgrep -v ':null' > ${PREFIX}I_workingname-sample.jsonl

cut -f 2 ${PREFIX}hair-eyes-sample.txt > ${PREFIX}hair-eyes-sample.jsonl

jq '{eyeColor: .eyeColor}' -c < ${PREFIX}hair-eyes-sample.jsonl | fgrep -v ':null' > ${PREFIX}eyes-sample.jsonl
jq '{hairType: .hairType}' -c < ${PREFIX}hair-eyes-sample.jsonl | fgrep -v ':null' > ${PREFIX}hair-sample.jsonl
