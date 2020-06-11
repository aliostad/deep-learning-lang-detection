(defproject om-sandbox "0.5.2"
  :description "ClojureScript interface to Facebook's React"
  :url "http://github.com/swannodette/om"
  :license {:name "Eclipse"
            :url "http://www.eclipse.org/legal/epl-v10.html"}

  :jvm-opts ^:replace ["-Xms512m" "-Xmx512m" "-server"]

  :source-paths  ["src"]

  :dependencies [[org.clojure/clojure "1.5.1"]
                 [org.clojure/clojurescript "0.0-2173" :scope "provided"]
                 [org.clojure/core.async "0.1.267.0-0d7780-alpha" :scope "provided"]
                 [com.facebook/react "0.9.0"]
                 [sablono "0.2.10"]]

  :plugins [[lein-cljsbuild "1.0.2"]]

  :cljsbuild
  {:builds [{:id "instrument"
             :source-paths ["src" "examples/instrument/src"]
             :compiler
             {:output-to "examples/instrument/main.js"
              :output-dir "examples/instrument/out"
              :source-map true
              :optimizations :none}}]})
