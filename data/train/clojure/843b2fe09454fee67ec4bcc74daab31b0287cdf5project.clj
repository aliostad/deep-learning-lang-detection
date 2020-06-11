(defproject airpair-clj-spark-introduction "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.6.0"]              ;; the road to simplicity
                 [yieldbot/flambo "0.4.0-SNAPSHOT"]         ;; the burning magic
                 [org.apache.spark/spark-core_2.10 "1.1.0"] ;; The beast :)
                 [log4j/log4j "1.2.17"]                     ;; control Spark logging better
                 [lein-light-nrepl "0.0.18"]                ;; needed if you use Ligthtable
                 [org.clojure/tools.namespace "0.2.7"]      ;; making it easy to repload our repl
                 [twitter-api "0.7.7"]                      ;; twitter api wrapper
                 [cheshire "5.3.1"]                         ;; fast json parsing
                 [clj-time "0.8.0"]                         ;; date parsing
                 [clj-http "1.0.1"]                         ;; clj-http
                 [environ "0.5.0"]                          ;; manage env variables
                 ]
  :main airpair-clj-spark-introduction.spark
  :repl-options {:nrepl-middleware [lighttable.nrepl.handler/lighttable-ops]}
  :aliases {"mine" ["run" "-m" "airpair-clj-spark-introduction.mine/-main"]}
  :profiles {:dev
              {:aot [airpair-clj-spark-introduction.core]}
           :uberjar
              {:aot :all}})
