#!/bin/bash
#echo "x"
#<<X

cp experiments/hyp2-svm/obesity_0026-0050.svm.model modelCache/default.svm.model
mv modelSource/obesity_0001-0050* modelCache/
cp modelCache/dict/deid+obes50/*txt modelCache/dict/
java -jar MultiScrubber.jar --jcarafe --stanford --illinois --dictionary --annotate obesity_1001-1249.clean.xml obesity_1001-1249.hyp2_1.xml
mv modelCache/obesity*xml* modelSource/
mv session/obesity_1001* experiments/hyp2-systems/1/
rm session/*

exit

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

cp experiments/hyp2-svm/obesity_0201-0400.svm.model modelCache/default.svm.model
mv modelSource/obesity_0001-0400* modelCache/
cp modelCache/dict/deid+obes400/*txt modelCache/dict/
java -jar MultiScrubber.jar --jcarafe --stanford --illinois --dictionary --annotate obesity_1001-1249.clean.xml obesity_1001-1249.hyp2_4.xml
mv modelCache/obesity*xml* modelSource/
mv session/obesity_1001* experiments/hyp2-systems/4/
rm session/*

rm modelCache/default.svm.model
rm modelCache/dict/*txt

echo "Done."

