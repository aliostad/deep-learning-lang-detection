(defproject react-hitch "0.1.6-SNAPSHOT"
  :description "A Clojurescript library designed to manage and cache derived data."
  :url "https://github.com/Breezeemr/react-hitch"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :scm "https://github.com/Breezeemr/react-hitch"
  :repositories [["snapshots" {:url "s3p://breezepackages/snapshots" :creds :gpg}]
                 ["releases" {:url "s3p://breezepackages/releases" :creds :gpg}]]
  :dependencies [[org.clojure/clojure "1.8.0" :scope "provided"]
                 [org.clojure/clojurescript "1.9.93" :scope "provided"]
                 [cljsjs/react-dom "0.14.0-1"]
                 [com.breezeehr/hitch "0.1.6-SNAPSHOT"]]
  :profiles {:dev {
                   :dependencies [[com.cemerick/piggieback "0.2.1"]    ; needed by figwheel nrepl
                                  [devcards "0.2.1"]]
                   :plugins        [[lein-figwheel "0.5.4-7"]]
                   :resource-paths ["dev-resources" "target/devcards"]
                   :figwheel       {:css-dirs       ["dev-resources/public/css"]
                                    :nrepl-port     7888
                                    :server-logfile "target/figwheel-logfile.log"}}}
  :source-paths ["src"]

  :clean-targets ^{:protect false} ["resources/public/js" "target"]

  :cljsbuild {
              :builds [{:id           "devcards"
                        :source-paths ["src" "test"]

                        :figwheel     {:devcards true}

                        :compiler     {:main          hitch.test-runner
                                       :asset-path    "js/devcardsout"
                                       :output-to     "target/devcards/public/js/react_hitch_devcards.js"
                                       :output-dir    "target/devcards/public/js/devcardsout"
                                       :optimizations :none
                                       :source-map true
                                       :source-map-timestamp false
                                       :cache-analysis true
                                       }}
                       {:id           "min"
                        :source-paths ["src"]
                        :compiler     {:output-to     "target/devcards/public/js/react-hitch.js"
                                       :main          hitch.reactjs
                                       :optimizations :advanced
                                       :pretty-print  false}}]})
