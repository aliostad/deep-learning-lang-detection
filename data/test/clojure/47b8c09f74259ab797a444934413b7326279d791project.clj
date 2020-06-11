(defproject m-clj "0.1.0-SNAPSHOT"
  :description "Code for Mastering Clojure"
  :uberjar-name "m-clj.jar"

  :java-agents [[co.paralleluniverse/quasar-core "0.7.3"]]
  :jvm-opts ["-Dco.paralleluniverse.pulsar.instrument.auto=all"]

  ;; :plugins [[lein-cljsbuild "1.1.0"]]

  :dependencies [[org.clojure/clojure "1.7.0"]
                 ;; [org.clojure/clojurescript "1.7.48"]
                 [org.clojure/math.numeric-tower "0.0.4"]
                 [defun "0.2.0-RC"]
                 [org.clojure/core.match "0.2.2"
                  :exclusions [org.clojure/tools.analyzer.jvm]]
                 [org.clojure/core.typed "0.3.0"]
                 [org.clojure/core.logic "0.8.10"]
                 [org.clojure/core.async "0.1.346.0-17112a-alpha"]
                 [com.climate/claypoole "1.0.0"]
                 [co.paralleluniverse/quasar-core "0.7.3"]
                 [co.paralleluniverse/pulsar "0.7.3"]
                 [iota "1.1.2"]
                 [funcool/cats "1.0.0"]])
