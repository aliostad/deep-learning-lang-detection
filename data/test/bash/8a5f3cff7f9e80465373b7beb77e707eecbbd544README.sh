#!/bin/bash

javac sample/SampleAction.java \
  sample/SampleAzn.java \
  sample/module/SampleLoginModule.java \
  sample/principal/SamplePrincipal.java

jar -cvf SampleAzn.jar sample/SampleAzn.class \
  sample/MyCallbackHandler.class
jar -cvf SampleAction.jar sample/SampleAction.class
jar -cvf SampleLM.jar \
  sample/module/SampleLoginModule.class \
  sample/principal/SamplePrincipal.class

java -classpath SampleAzn.jar:SampleAction.jar:SampleLM.jar \
  -Djava.security.manager \
  -Djava.security.policy=sampleazn.policy \
  -Djava.security.auth.login.config=sample_jaas.config \
  sample.SampleAzn
