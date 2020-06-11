javac sample/SampleAcn.java \
  sample/module/SampleLoginModule.java \
  sample/principal/SamplePrincipal.java

# Without a security manager
java -Djava.security.auth.login.config=sample_jaas.config \
  sample.SampleAcn

# Will fail
java -Djava.security.manager \
  -Djava.security.auth.login.config=sample_jaas.config sample.SampleAcn

# with a security manager
jar -cvf SampleAcn.jar sample/SampleAcn.class \
  sample/MyCallbackHandler.class
jar -cvf SampleLM.jar sample/module/SampleLoginModule.class \
  sample/principal/SamplePrincipal.class
java -classpath SampleAcn.jar:SampleLM.jar \
  -Djava.security.manager \
  -Djava.security.policy=sampleacn.policy \
  -Djava.security.auth.login.config=sample_jaas.config \
  sample.SampleAcn

