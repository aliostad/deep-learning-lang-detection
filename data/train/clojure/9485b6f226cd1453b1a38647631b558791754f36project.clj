(defproject postgres-component "0.1.0-SNAPSHOT"
  :description "A component to manage a PostgreSQL connection"
  :url "https://github.com/zonotope/postgres-component"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.8.0"]
                 [com.stuartsierra/component "0.3.1"]
                 [org.postgresql/postgresql "9.4.1208"]
                 [org.clojure/java.jdbc "0.6.1"]
                 [hikari-cp "1.7.1"]])
