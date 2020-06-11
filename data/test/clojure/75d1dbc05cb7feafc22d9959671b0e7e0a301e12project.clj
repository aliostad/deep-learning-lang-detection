(defproject clojure-processing-sketch-example "0.1.0-SNAPSHOT"
  :description "manage exported processing sketches from clojure"
  :url "https://github.com/benswift/clojure-processing-sketch-example"
  :main clojure-processing-sketch-example.core
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.8.0"]
                 [org.processing/core "3.2.1"]
                 [comp1720/Jukebox "0.0.0-SNAPSHOT"]]
  :java-source-paths ["src/sketches"]
  :plugins [[lein-localrepo "0.5.3"]])
