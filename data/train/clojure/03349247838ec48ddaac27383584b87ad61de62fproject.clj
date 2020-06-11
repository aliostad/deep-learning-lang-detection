(defproject flambo-example "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [
    [org.clojure/clojure "1.7.0-alpha5"]
    [org.clojure/core.async "0.1.346.0-17112a-alpha"]
    [twitter-api "0.7.7"]
    [yieldbot/flambo "0.5.0-SNAPSHOT"]
    [org.apache.spark/spark-core_2.10 "1.3.0"]
    [cheshire "5.3.1"]                         ;; fast json parsing
    [clj-time "0.8.0"]                         ;; date parsing
    [clj-http "1.0.1"]                         ;; clj-http
    [environ "0.5.0"]                          ;; manage env variables
    ]

  :main flambo-example.spark             ;; lein run will execute main.
  :repl-options {:nrepl-middleware []}
  :aliases {"mine" ["run" "-m" "flambo-example.mine/-main"]}
  :profiles {:dev
              {:aot [flambo-example.core]}
             :uberjar
              {:aot :all}}
  )
