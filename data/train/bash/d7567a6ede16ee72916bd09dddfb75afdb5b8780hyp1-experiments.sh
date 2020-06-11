#!/bin/bash
#echo "x"
#<<X

mkdir experiments/hyp1-results/

cp experiments/hyp1-svm/obesity_0026-0050.svm.model modelCache/default.svm.model

mv modelSource/obesity_0001-0025* modelCache/
java -jar MultiScrubber.jar --jcarafe --stanford --illinois --annotate obesity_1001-1249.clean.xml obesity_1001-1249.25-25.xml
mv modelCache/obesity*xml* modelSource/

mv modelSource/obesity_0001-0050* modelCache/
java -jar MultiScrubber.jar --jcarafe --stanford --illinois --annotate obesity_1001-1249.clean.xml obesity_1001-1249.50-25.xml
mv modelCache/obesity*xml* modelSource/


cp experiments/hyp1-svm/obesity_0051-0100.svm.model modelCache/default.svm.model

mv modelSource/obesity_0001-0050* modelCache/
java -jar MultiScrubber.jar --jcarafe --stanford --illinois --annotate obesity_1001-1249.clean.xml obesity_1001-1249.50-50.xml
mv modelCache/obesity*xml* modelSource/

mv modelSource/obesity_0001-0100* modelCache/
java -jar MultiScrubber.jar --jcarafe --stanford --illinois --annotate obesity_1001-1249.clean.xml obesity_1001-1249.100-50.xml
mv modelCache/obesity*xml* modelSource/


cp experiments/hyp1-svm/obesity_0101-0200.svm.model modelCache/default.svm.model

mv modelSource/obesity_0001-0100* modelCache/
java -jar MultiScrubber.jar --jcarafe --stanford --illinois --annotate obesity_1001-1249.clean.xml obesity_1001-1249.100-100.xml
mv modelCache/obesity*xml* modelSource/

mv modelSource/obesity_0001-0200* modelCache/
java -jar MultiScrubber.jar -d --jcarafe --stanford --illinois --annotate obesity_1001-1249.clean.xml obesity_1001-1249.200-100.xml
mv modelCache/obesity*xml* modelSource/

#X

cp experiments/hyp1-svm/obesity_0201-0400.svm.model modelCache/default.svm.model

mv modelSource/obesity_0001-0200* modelCache/
java -jar MultiScrubber.jar --jcarafe --stanford --illinois --annotate obesity_1001-1249.clean.xml obesity_1001-1249.200-200.xml
mv modelCache/obesity*xml* modelSource/

mv modelSource/obesity_0001-0400* modelCache/
java -jar MultiScrubber.jar --jcarafe --stanford --illinois --annotate obesity_1001-1249.clean.xml obesity_1001-1249.400-200.xml
mv modelCache/obesity*xml* modelSource/

rm modelCache/default.svm.model

mv obesity_1001-1249.*-*.xml experiments/hyp1-results/

echo "Done."



