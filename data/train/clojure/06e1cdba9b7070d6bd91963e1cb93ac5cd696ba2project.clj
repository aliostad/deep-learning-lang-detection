(defproject om-state-stream "0.1.0-SNAPSHOT"
  :description "port of react-state-stream to Om"
  :url "http://example.com/FIXME"

  :dependencies [[org.clojure/clojure "1.6.0"]
                 [org.clojure/clojurescript "0.0-2657"]
                 [org.clojure/core.async "0.1.346.0-17112a-alpha"]
                 [om "0.8.0-rc1"]]

  :plugins [[lein-cljsbuild "1.0.4"]]

  :source-paths ["src"]

  :clean-targets ["out/om_state_stream" "om_state_stream.js"]

  :cljsbuild {
    :builds [{:id "om-state-stream"
              :source-paths ["src"]
              :compiler {
                :output-to "om_state_stream.js"
                :output-dir "out"
                :optimizations :none
                :cache-analysis true
                :source-map true}}]})
