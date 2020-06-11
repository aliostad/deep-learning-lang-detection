(defproject sms-application "0.1.0-SNAPSHOT"
  :description "An sms application designed to use a built in messaging system, web-texts and standard sms functionalities."
  :url "https://github.com/Severed-Infinity/sms-application"
  :license {:name "Eclipse Public License"
            :url  "http://www.eclipse.org/legal/epl-v10.html"}
  :min-lein-version "2.0.0"
  :dependencies [[org.clojure/clojure "1.7.0"]
                 [co.paralleluniverse/pulsar "0.7.4" :exclusions [[org.clojure/tools.analyzer.jvm] [org.clojure/tools.analyzer] [org.clojure/tools.reader]]]
                 [co.paralleluniverse/comsat-httpkit "0.5.0" :exclusions [[org.clojure/tools.reader]]]
                 [bidi "2.0.6"]
                 [cheshire "5.6.1"]
                 [environ "1.0.2"]
                 [ring/ring-core "1.4.0"]
                 #_[im.chit/hara.time "2.2.17"]
                 [clj-time "0.11.0"]
                 ;requirement for ring multipart
                 [javax.servlet/servlet-api "2.5"]]
  :plugins [[lein-environ "1.0.2"]]
  :java-agents [[co.paralleluniverse/quasar-core "0.7.4" :classifier "jdk8" :options "m"]]
  :manifest {"Premain-Class"           "co.paralleluniverse.fibers.instrument.JavaAgent"
             "Agent-Class"             "co.paralleluniverse.fibers.instrument.JavaAgent"
             "Can-Retransform-Classes" "true"
             "Can-Redefine-Classes"    "true"}
  :bootclasspath true
  :main sms-application.core
  :target-path "target/%s"
  :uberjar-name "sfinity-server.jar"
  :aot [sms-application.core]
  :profiles {:production {}
             :uberjar    {:aot :all}
             :auto-instrument-all
                         {:jvm-opts ["-Dco.paralleluniverse.pulsar.instrument.auto=all"
                                     "-Dco.paralleluniverse.fibers.verifyInstrumentation=true"]}}
  :capsule {:types {:fat {:name "sfinity-server-capsule.jar"}}}
  :heroku {:app-name      "sfinity-server"
           :jdk-version   "1.8"
           :include-files ["target/uberjar/sfinity-server.jar"]
           #_{:process-type ["web java -jar target/uberjar/sfinity-server.jar"]}})
