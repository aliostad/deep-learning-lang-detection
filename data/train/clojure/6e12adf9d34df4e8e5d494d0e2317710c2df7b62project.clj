(defproject ovation-webapi "1.0.0-SNAPSHOT"
  :min-lein-version "2.5.0"
  :description "Ovation REST API"
  :url "http://ovation.io"

  :dependencies [[org.clojure/clojure "1.8.0"]
                 [org.clojure/core.async "0.3.443"]

                 ;; To manage compojure's outdated deps
                 [commons-codec "1.10" :exclusions [[org.clojure/clojure]]]

                 ;; Component
                 [com.stuartsierra/component "0.3.2"]
                 [org.danielsz/system "0.4.0"]

                 ;; Compojure API and middleware
                 [metosin/compojure-api "1.1.11"]
                 ;[metosin/ring-http-response "0.9.0"]
                 [ring-cors "0.1.11"]
                 [ring-logger "0.7.7"]
                 [buddy/buddy-auth "1.4.1"]


                 ;; HTTP and CouchDB
                 [http-kit "2.2.0"]
                 [org.clojure/data.codec "0.1.0"]
                 [com.ashafa/clutch "0.4.0"]

                 ;; New Relic agent (JAR)
                 [com.newrelic.agent.java/newrelic-agent "3.43.0"]
                 [yleisradio/new-reliquary "1.0.0"]
                 [com.climate/clj-newrelic "0.2.1"]

                 ;; Raygun
                 [com.mindscapehq/core "2.2.0"]

                 ;; Logging
                 ; Use Logback for logging
                 [ch.qos.logback/logback-classic "1.2.3"]
                 [org.clojure/tools.logging "0.4.0"]
                 [potemkin "0.4.4"]

                 ; Route all other logging to Logback
                 [org.slf4j/log4j-over-slf4j "1.7.25"]
                 [org.slf4j/jul-to-slf4j "1.7.25"]
                 [org.slf4j/jcl-over-slf4j "1.7.25"]


                 ;; Other
                 [org.clojure/data.json "0.2.6"]
                 [com.googlecode.owasp-java-html-sanitizer/owasp-java-html-sanitizer "20160628.1" :exclusions [com.google.guava/guava]]
                 [environ "1.1.0"]

                 ;; Graph
                 [ubergraph "0.2.2"]

                 ;; GCP
                 [com.google.cloud/google-cloud "0.18.0-alpha"]

                 ;; Elasticsearch
                 [cc.qbits/spandex "0.5.2"]
                 [org.elasticsearch.client/rest "5.5.0"]    ;; This is a spandex dependency, but we're not getting transitive deps unless it's included explicitly
                 ]


  :ring {:handler ovation.handler/app
         :main    ovation.main}

  :main ovation.main

  :resource-paths ["resources"]

  :profiles {:dev      {:dependencies [[ring-mock "0.1.5"]
                                       [midje "1.8.3"]
                                       [http-kit.fake "0.2.2"]
                                       [ring-server "0.5.0"]]
                        :plugins      [[lein-midje "3.2.1"]
                                       [lein-ring "0.12.1"]]}

             :uberjar  {:aot [ovation.main]}

             :newrelic {:java-agents [[com.newrelic.agent.java/newrelic-agent "3.28.0"]]
                        :jvm-opts    ["-Dnewrelic.config.file=/app/newrelic/newrelic.yml"]}

             :jmx      {:jvm-opts ["-Dcom.sun.management.jmxremote"
                                   "-Dcom.sun.management.jmxremote.ssl=false"
                                   "-Dcom.sun.management.jmxremote.authenticate=false"
                                   "-Dcom.sun.management.jmxremote.port=43210"]}})

