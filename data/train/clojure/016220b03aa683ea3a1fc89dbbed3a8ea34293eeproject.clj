(defproject com.weareinstrument/websockets "0.1.0-SNAPSHOT"
  :description "Basic Clojure websockets server"
  :url "https://github.com/Instrument/clojure-websockets"
  
  :dependencies [[org.clojure/clojure "1.5.1"]
                 [cheshire "5.2.0"]
                 [com.keminglabs/jetty7-websockets-async "0.1.0-SNAPSHOT"]
                 [org.clojure/core.async "0.1.0-SNAPSHOT"]
                 [ring/ring-jetty-adapter "1.2.0"]
                 [compojure "1.1.5" :exclusions [ring/ring-core]]]

  :repositories {"sonatype-oss-public" "https://oss.sonatype.org/content/groups/public/"}
  :min-lein-version "2.0.0"
  
  :plugins [[lein-ring "0.8.7"]
            [lein-cljsbuild "0.3.2"]]
  :ring {:handler websockets.core/app}
  
  :source-paths ["src/clj" "src/cljs"]
  
  :cljsbuild {:builds
              [{:source-paths ["src/cljs"]
                :compiler {:output-to "public/websockets-client.js"
                           :pretty-print true
                           :optimizations :whitespace}}]})