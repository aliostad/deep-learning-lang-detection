(defproject hallway "0.1.0-SNAPSHOT"
  :description "Small tool to manage patient list"
  :repl-options {
                 :port 4500
                 :init-ns hallway.core
   }
  :dependencies [
                 [org.clojure/clojure "1.5.1"]
                 [seesaw "1.4.3"]
                 [com.github.insubstantial/substance "7.1"]
                 [com.h2database/h2 "1.3.171"]
                 [org.clojure/java.jdbc "0.2.3"]
                 [com.toedter/jcalendar "1.3.2"]
                 [net.sf.jasperreports/jasperreports "5.0.4"]
                 [org.clojure/tools.logging "0.2.6"]
                 [ch.qos.logback/logback-classic "1.0.11"]
                 ]
  :main hallway.core)
