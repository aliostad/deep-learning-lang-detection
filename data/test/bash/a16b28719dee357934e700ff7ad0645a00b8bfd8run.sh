#!/bin/sh
# ----------------------------------------------------------------------------
#  Copyright 2001-2006 The Apache Software Foundation.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# ----------------------------------------------------------------------------

#   Copyright (c) 2001-2002 The Apache Software Foundation.  All rights
#   reserved.

BASEDIR=`dirname $0`/..
BASEDIR=`(cd "$BASEDIR"; pwd)`

[ -f "$BASEDIR"/bin/setenv.sh ] && . "$BASEDIR"/bin/setenv.sh

# OS specific support.  $var _must_ be set to either true or false.
cygwin=false;
darwin=false;
case "`uname`" in
  CYGWIN*) cygwin=true ;;
  Darwin*) darwin=true
           if [ -z "$JAVA_VERSION" ] ; then
             JAVA_VERSION="CurrentJDK"
           else
             echo "Using Java version: $JAVA_VERSION"
           fi
           if [ -z "$JAVA_HOME" ] ; then
             JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/${JAVA_VERSION}/Home
           fi
           ;;
esac

if [ -z "$JAVA_HOME" ] ; then
  if [ -r /etc/gentoo-release ] ; then
    JAVA_HOME=`java-config --jre-home`
  fi
fi

# For Cygwin, ensure paths are in UNIX format before anything is touched
if $cygwin ; then
  [ -n "$JAVA_HOME" ] && JAVA_HOME=`cygpath --unix "$JAVA_HOME"`
  [ -n "$CLASSPATH" ] && CLASSPATH=`cygpath --path --unix "$CLASSPATH"`
fi

# If a specific java binary isn't specified search for the standard 'java' binary
if [ -z "$JAVACMD" ] ; then
  if [ -n "$JAVA_HOME"  ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
      # IBM's JDK on AIX uses strange locations for the executables
      JAVACMD="$JAVA_HOME/jre/sh/java"
    else
      JAVACMD="$JAVA_HOME/bin/java"
    fi
  else
    JAVACMD=`which java`
  fi
fi

if [ ! -x "$JAVACMD" ] ; then
  echo "Error: JAVA_HOME is not defined correctly."
  echo "  We cannot execute $JAVACMD"
  exit 1
fi

if [ -z "$REPO" ]
then
  REPO="$BASEDIR"/lib
fi

CLASSPATH=$CLASSPATH_PREFIX:"$BASEDIR"/config:"$REPO"/nbxml-0.7.jar:"$REPO"/vysper-core-0.7.jar:"$REPO"/commons-io-1.4.jar:"$REPO"/commons-lang-2.5.jar:"$REPO"/dnsjava-2.0.8.jar:"$REPO"/xep0045-muc-0.7.jar:"$REPO"/xep0060-pubsub-0.7.jar:"$REPO"/xep0124-xep0206-bosh-0.7.jar:"$REPO"/jetty-servlet-7.2.1.v20101111.jar:"$REPO"/jetty-security-7.2.1.v20101111.jar:"$REPO"/vysper-websockets-0.7.jar:"$REPO"/jetty-websocket-7.2.1.v20101111.jar:"$REPO"/jetty-server-7.2.1.v20101111.jar:"$REPO"/jetty-continuation-7.2.1.v20101111.jar:"$REPO"/jetty-http-7.2.1.v20101111.jar:"$REPO"/jetty-io-7.2.1.v20101111.jar:"$REPO"/jetty-util-7.2.1.v20101111.jar:"$REPO"/servlet-api-2.5.jar:"$REPO"/spring-context-3.0.5.RELEASE.jar:"$REPO"/spring-aop-3.0.5.RELEASE.jar:"$REPO"/aopalliance-1.0.jar:"$REPO"/spring-beans-3.0.5.RELEASE.jar:"$REPO"/spring-core-3.0.5.RELEASE.jar:"$REPO"/spring-expression-3.0.5.RELEASE.jar:"$REPO"/spring-asm-3.0.5.RELEASE.jar:"$REPO"/mina-core-2.0.2.jar:"$REPO"/jcr-1.0.jar:"$REPO"/jackrabbit-core-1.5.3.jar:"$REPO"/concurrent-1.3.4.jar:"$REPO"/commons-collections-3.1.jar:"$REPO"/jackrabbit-api-1.5.0.jar:"$REPO"/jackrabbit-jcr-commons-1.5.3.jar:"$REPO"/jackrabbit-spi-commons-1.5.0.jar:"$REPO"/jackrabbit-spi-1.5.0.jar:"$REPO"/jackrabbit-text-extractors-1.5.0.jar:"$REPO"/poi-3.0.2-FINAL.jar:"$REPO"/commons-logging-1.1.jar:"$REPO"/poi-scratchpad-3.0.2-FINAL.jar:"$REPO"/pdfbox-0.7.3.jar:"$REPO"/fontbox-0.1.0.jar:"$REPO"/jempbox-0.2.0.jar:"$REPO"/nekohtml-1.9.7.jar:"$REPO"/xercesImpl-2.8.1.jar:"$REPO"/xml-apis-1.3.03.jar:"$REPO"/lucene-core-2.3.2.jar:"$REPO"/derby-10.2.1.6.jar:"$REPO"/commons-codec-1.4.jar:"$REPO"/slf4j-api-1.5.3.jar:"$REPO"/slf4j-log4j12-1.5.3.jar:"$REPO"/log4j-1.2.14.jar:"$REPO"/jcl-over-slf4j-1.5.3.jar:"$REPO"/spec-compliance-0.7.jar:"$REPO"/ehcache-core-2.2.0.jar:"$REPO"/vysper-0.7.pom
EXTRA_JVM_ARGUMENTS=""

# For Cygwin, switch paths to Windows format before running java
if $cygwin; then
  [ -n "$CLASSPATH" ] && CLASSPATH=`cygpath --path --windows "$CLASSPATH"`
  [ -n "$JAVA_HOME" ] && JAVA_HOME=`cygpath --path --windows "$JAVA_HOME"`
  [ -n "$HOME" ] && HOME=`cygpath --path --windows "$HOME"`
  [ -n "$BASEDIR" ] && BASEDIR=`cygpath --path --windows "$BASEDIR"`
  [ -n "$REPO" ] && REPO=`cygpath --path --windows "$REPO"`
fi

exec "$JAVACMD" $JAVA_OPTS \
  $EXTRA_JVM_ARGUMENTS \
  -classpath "$CLASSPATH" \
  -Dapp.name="run.sh" \
  -Dapp.pid="$$" \
  -Dapp.repo="$REPO" \
  -Dbasedir="$BASEDIR" \
  org.apache.vysper.spring.ServerMain \
  "$@"
