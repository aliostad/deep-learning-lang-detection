(defproject colliery "0.1.0-SNAPSHOT"
  :description "API service for web UI"
  :url "http://github.com/alexkalderimis/colliery"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :main colliery.core
  :source-paths ["src"]
  :test-paths ["test"]
  :resource-paths ["resources"]
  :test-selectors {:all (constantly true) :db :db}
  :plugins [
    [lein-bikeshed "0.1.3"]
    [lein-environ "0.4.0"]]
  :dependencies [
    [org.clojure/clojure "1.4.0"]
    [log4j "1.2.15" :exclusions [javax.mail/mail javax.jms/jms com.sun.jdmk/jmxtools com.sun.jmx/jmxri]]
    [postgresql "9.1-901.jdbc4"] ;; db driver
    [com.cemerick/friend "0.2.0"] ;; security
    [org.clojure/tools.logging "0.2.6"] ;; logging
    [org.clojure/java.jdbc "0.2.2"] ;; Korma wants this, lobos wants 0.1.1. Korma wins
    [environ "0.4.0"] ;; manage config variables
    [lobos "1.0.0-beta1"] ;; handle db schema and migrations
    [korma "0.3.0-RC6"] ;; sql queries and data management
    [ring/ring-jetty-adapter "1.1.6"] ;; http server
    [hiccup "1.0.2"] ;; html templating
    [compojure "1.1.3"]]) 
