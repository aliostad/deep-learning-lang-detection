(defproject manage-topics "0.1.0"
  :description "Create a kafka producer and high level consumer"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.8.0"]
                 [org.clojure/tools.cli "0.3.3"]
                 [org.clojure/tools.logging "0.3.1"]
                 [ymilky/franzy-admin "0.0.1"]
                 [clojure-ini "0.0.2"]
                 [log4j/log4j "1.2.17" :exclusions [javax.mail/mail
                                                    javax.jms/jms
                                                    com.sun.jmdk/jmxtools
                                                    com.sun.jmx/jmxri]]]
  :plugins [[lein-bin "0.3.5"]]
  :bin { :name "manage-topics" }
  :aot [manage-topics.core]
  :main manage-topics.core)
