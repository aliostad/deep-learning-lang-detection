#!/bin/bash

mv modelSource/obesity_0001-0025* modelCache/
java -jar MultiScrubber.jar --jcarafe --stanford --illinois --train-meta obesity_0026-0050.xml
mv modelCache/default.svm.model experiments/hyp1-svm/obesity_0026-0050.svm.model
mv modelCache/obesity*xml* modelSource/
rm session/*

mv modelSource/obesity_0001-0050* modelCache/
java -jar MultiScrubber.jar --jcarafe --stanford --illinois --train-meta obesity_0051-0100.xml
mv modelCache/default.svm.model experiments/hyp1-svm/obesity_0051-0100.svm.model
mv modelCache/obesity*xml* modelSource/
rm session/*

mv modelSource/obesity_0001-0100* modelCache/
java -jar MultiScrubber.jar --jcarafe --stanford --illinois --train-meta obesity_0101-0200.xml
mv modelCache/default.svm.model experiments/hyp1-svm/obesity_0101-0200.svm.model
mv modelCache/obesity*xml* modelSource/
rm session/*

mv modelSource/obesity_0001-0200* modelCache/
java -jar MultiScrubber.jar --jcarafe --stanford --illinois --train-meta obesity_0201-0400.xml
mv modelCache/default.svm.model experiments/hyp1-svm/obesity_0201-0400.svm.model
mv modelCache/obesity*xml* modelSource/
rm session/*

mv modelSource/obesity_0001-0400* modelCache/
java -jar MultiScrubber.jar --jcarafe --stanford --illinois --train-meta obesity_0401-0800.xml
mv modelCache/default.svm.model experiments/hyp1-svm/obesity_0401-0800.svm.model
mv modelCache/obesity*xml* modelSource/
rm session/*

