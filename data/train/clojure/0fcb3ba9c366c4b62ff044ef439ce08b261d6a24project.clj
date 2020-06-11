(defproject org.scheibenkaes/startech "0.1.0-SNAPSHOT"
  :description "Manage TechTalks"
  :url "http://github.com/scheibenkaes/startech"

  :dependencies [[org.clojure/clojure "1.6.0"]
                 [org.clojure/clojurescript "0.0-2311"]
                 [org.clojure/core.async "0.1.267.0-0d7780-alpha"]
                 [om "0.7.3"]
                 [prismatic/om-tools "0.3.6"]]

  :plugins [[lein-cljsbuild "1.0.4-SNAPSHOT"]]

  :source-paths ["src"]

  :cljsbuild { 
    :builds [{:id "startech"
              :source-paths ["src"]
              :compiler {
                :output-to "resources/public/startech.js"
                :output-dir "resources/public/out"
                :optimizations :none
                :source-map true}}]})
