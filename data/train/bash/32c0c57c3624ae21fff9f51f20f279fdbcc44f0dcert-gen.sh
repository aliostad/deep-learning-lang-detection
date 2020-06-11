#!/bin/sh
REPO=$HOME/.m2/repository
DEPENDENCIES=$REPO/org/scala-lang/scala-library/2.8.0/scala-library-2.8.0.jar:$REPO/org/scala-lang/scala-compiler/2.8.0/scala-compiler-2.8.0.jar:$REPO/org/bouncycastle/bcprov-jdk16/1.44/bcprov-jdk16-1.44.jar:$REPO/org/bouncycastle/bcpg-jdk16/1.44/bcpg-jdk16-1.44.jar:$REPO/log4j/log4j/1.2.14/log4j-1.2.14.jar:$REPO/org/slf4j/slf4j-api/1.5.8/slf4j-api-1.5.8.jar:$REPO/org/slf4j/slf4j-log4j12/1.4.2/slf4j-log4j12-1.4.2.jar:target/cert-generation-1.0.0.jar

java -cp $DEPENDENCIES com.redhat.certgen.CLI $*