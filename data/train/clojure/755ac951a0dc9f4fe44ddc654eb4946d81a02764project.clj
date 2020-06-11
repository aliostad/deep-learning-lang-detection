(defproject ods-service "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url  "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.7.0"]
                 [com.oracle.oracle/ojdbc6 "11.2.0.2.0"]
                 [org.clojure/java.jdbc "0.3.5"]
                 [org.clojure/data.csv "0.1.2"]
                 [org.clojure/core.async "0.1.346.0-17112a-alpha"]
                 [org.clojure/test.check "0.8.0-ALPHA"]
                 [org.clojure/core.cache "0.6.4"]
                 [org.apache.derby/derbyclient "10.8.2.2"]
                 [prismatic/schema "1.0.1"]
                 ]
  :aot [util.irds]
  :main feed.irds-instrument
  ;;:offline? true
  :local-repo "c:/Users/bulaole/.m2/repository"
  )
