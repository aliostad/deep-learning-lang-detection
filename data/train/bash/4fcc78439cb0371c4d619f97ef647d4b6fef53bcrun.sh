#!/bin/sh
COMPILED_PLUGIN_PATH=./target/scala-2.11/classes
SAMPLE_SCALA_FILE=samplescalafile
SAMPLE_SCALA_CLASS=Nima
SAMPLE_CLASS_PATH=./src/test/scala-2.11
SAMPLE_CLASS_COMPILED_PATH=./target/scala-2.11/test-classes

rm -f ${SAMPLE_CLASS_COMPILED_PATH}/${SAMPLE_SCALA_CLASS}*.class
scalac -Ylog:verbose-logger \
       -Xprint:verbose-logger \
       -Xplugin:${COMPILED_PLUGIN_PATH} \
       -d ${SAMPLE_CLASS_COMPILED_PATH} \
       ${SAMPLE_CLASS_PATH}/${SAMPLE_SCALA_FILE}.scala
java -cp ~/.ivy2/cache/org.scala-lang/scala-library/jars/scala-library-2.12.1.jar ${SAMPLE_SCALA_CLASS}