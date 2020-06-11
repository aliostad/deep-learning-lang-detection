M2_REPO=~/.m2/repository
CP=

CP=$CP:$M2_REPO/pertinence/indexer_app/0.9/indexer_app-1.0.jar
CP=$CP:$M2_REPO/com/thoughtworks/xstream/xstream/1.3/xstream-1.3.jar
CP=$CP:$M2_REPO/xpp3/xpp3_min/1.1.4c/xpp3_min-1.1.4c.jar
CP=$CP:$M2_REPO/commons-io/commons-io/1.4/commons-io-1.4.jar
CP=$CP:$M2_REPO/commons-lang/commons-lang/2.4/commons-lang-2.4.jar
CP=$CP:$M2_REPO/junit/junit/4.5/junit-4.5.jar
CP=$CP:$M2_REPO/log4j/log4j/1.2.15/log4j-1.2.15.jar
CP=$CP:$M2_REPO/org/apache/lucene/lucene-analyzers/2.4.0/lucene-analyzers-2.4.0.jar
CP=$CP:$M2_REPO/org/apache/lucene/lucene-snowball/2.4.0/lucene-snowball-2.4.0.jar
CP=$CP:$M2_REPO/org/apache/lucene/lucene-core/2.4.0/lucene-core-2.4.0.jar
CP=$CP:$M2_REPO/org/apache/lucene/lucene-wikipedia/2.4.0/lucene-wikipedia-2.4.0.jar
CP=$CP:$M2_REPO/org/apache/lucene/lucene-benchmark/2.4.0/lucene-benchmark-2.4.0.jar
CP=$CP:$M2_REPO/org/apache/lucene/lucene-demos/2.4.0/lucene-demos-2.4.0.jar
CP=$CP:$M2_REPO/commons-beanutils/commons-beanutils/1.7.0/commons-beanutils-1.7.0.jar
CP=$CP:$M2_REPO/commons-cli/commons-cli/1.1/commons-cli-1.1.jar
CP=$CP:$M2_REPO/commons-logging/commons-logging/1.0.4/commons-logging-1.0.4.jar
CP=$CP:$M2_REPO/commons-collections/commons-collections/3.1/commons-collections-3.1.jar
CP=$CP:$M2_REPO/commons-digester/commons-digester/1.7/commons-digester-1.7.jar
CP=$CP:$M2_REPO/xml-apis/xml-apis/1.0.b2/xml-apis-1.0.b2.jar

#export CP


java -Xmx1000 -Dfile.encoding=UTF-8 -classpath $CP wiki.indexer.OptimizeIndex $*