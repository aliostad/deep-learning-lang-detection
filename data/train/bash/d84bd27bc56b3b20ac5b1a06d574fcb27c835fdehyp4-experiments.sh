#!/bin/bash

mkdir experiments/hyp4-systems/
mkdir experiments/hyp4-results/

mv modelSource/official-deid* modelCache/

echo "X"
<<X

cp experiments/hyp2-svm/obesity_0026-0050.svm.model modelCache/default.svm.model
mv modelSource/obesity_0001-0050* modelCache/
cp modelCache/dict/deid+obes50/*txt modelCache/dict/
java -jar MultiScrubber.jar --jcarafe --stanford --illinois --dictionary --annotate obesity_1001-1249.clean.xml obesity_1001-1249.hyp2_1.xml
mv modelCache/obesity*xml* modelSource/
mv session/obesity_1001* experiments/hyp2-systems/1/
rm session/*

cp experiments/hyp2-svm/obesity_0051-0100.svm.model modelCache/default.svm.model
mv modelSource/obesity_0001-0100* modelCache/
cp modelCache/dict/deid+obes100/*txt modelCache/dict/
java -jar MultiScrubber.jar --jcarafe --stanford --illinois --dictionary --annotate obesity_1001-1249.clean.xml obesity_1001-1249.hyp2_2.xml
mv modelCache/obesity*xml* modelSource/
mv session/obesity_1001* experiments/hyp2-systems/2/
rm session/*

cp experiments/hyp2-svm/obesity_0101-0200.svm.model modelCache/default.svm.model
mv modelSource/obesity_0001-0200* modelCache/
cp modelCache/dict/deid+obes200/*txt modelCache/dict/
java -jar MultiScrubber.jar --jcarafe --stanford --illinois --dictionary --annotate obesity_1001-1249.clean.xml obesity_1001-1249.hyp2_3.xml
mv modelCache/obesity*xml* modelSource/
mv session/obesity_1001* experiments/hyp2-systems/3/
rm session/*

X

cp experiments/hyp2-svm/obesity_0401-0800.svm.model modelCache/default.svm.model
mv modelSource/obesity_0001-0800* modelCache/
cp modelCache/dict/deid+obes800/*txt modelCache/dict/
java -jar MultiScrubber.jar --jcarafe --stanford --illinois --dictionary --annotate obesity_1001-1249.clean.xml obesity_1001-1249.hyp4.xml
mv modelCache/obesity*xml* modelSource/
mv session/obesity_1001* experiments/hyp4-systems/
rm session/*

mv modelCache/official-deid* modelSource/

rm modelCache/default.svm.model
rm modelCache/dict/*txt

mv obesity_1001-1249.hyp4.xml experiments/hyp4-results/

echo "Done."

