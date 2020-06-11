#!/bin/bash

mv modelSource/obesity_0001-0025* modelCache/
cp modelCache/dict/deid+obes25/*txt modelCache/dict/
java -jar MultiScrubber.jar --jcarafe --stanford --illinois --dictionary --train-meta obesity_0026-0050.xml
mv modelCache/default.svm.model experiments/hyp2-svm/obesity_0026-0050.svm.model
mv modelCache/obesity*xml* modelSource/
rm session/*

mv modelSource/obesity_0001-0050* modelCache/
cp modelCache/dict/deid+obes50/*txt modelCache/dict/
java -jar MultiScrubber.jar --jcarafe --stanford --illinois --dictionary --train-meta obesity_0051-0100.xml
mv modelCache/default.svm.model experiments/hyp2-svm/obesity_0051-0100.svm.model
mv modelCache/obesity*xml* modelSource/
rm session/*

mv modelSource/obesity_0001-0100* modelCache/
cp modelCache/dict/deid+obes100/*txt modelCache/dict/
java -jar MultiScrubber.jar --jcarafe --stanford --illinois --dictionary --train-meta obesity_0101-0200.xml
mv modelCache/default.svm.model experiments/hyp2-svm/obesity_0101-0200.svm.model
mv modelCache/obesity*xml* modelSource/
rm session/*

mv modelSource/obesity_0001-0200* modelCache/
cp modelCache/dict/deid+obes200/*txt modelCache/dict/
java -jar MultiScrubber.jar --jcarafe --stanford --illinois --dictionary --train-meta obesity_0201-0400.xml
mv modelCache/default.svm.model experiments/hyp2-svm/obesity_0201-0400.svm.model
mv modelCache/obesity*xml* modelSource/
rm session/*

mv modelSource/obesity_0001-0400* modelCache/
cp modelCache/dict/deid+obes400/*txt modelCache/dict/
java -jar MultiScrubber.jar --jcarafe --stanford --illinois --dictionary --train-meta obesity_0401-0800.xml
mv modelCache/default.svm.model experiments/hyp2-svm/obesity_0401-0800.svm.model
mv modelCache/obesity*xml* modelSource/
rm session/*

rm modelCache/dict/*txt

echo "Done."

