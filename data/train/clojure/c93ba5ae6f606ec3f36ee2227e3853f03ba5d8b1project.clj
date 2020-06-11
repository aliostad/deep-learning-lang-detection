(defproject timeclock "0.8.0"
  :description "Manage work time"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [;; clj
                 [org.clojure/clojure "1.9.0-alpha12"]
                 [com.stuartsierra/component "0.3.1"]
                 [compojure "1.5.1"]
                 [liberator "0.14.1"]
                 [cheshire "5.6.3"]
                 [io.clojure/liberator-transit "0.3.0"]
                 [ring/ring-defaults "0.2.1"]
                 [ring/ring-devel "1.5.0"]
                 [ring-middleware-format "0.7.0"]
                 [aleph "0.4.2-alpha8"]
                 [org.clojure/tools.logging "0.3.1"]
                 [ch.qos.logback/logback-classic "1.1.7"]
                 [com.novemberain/monger "3.1.0" :exclusions [com.google.guava/guava]]
                 [levand/immuconf "0.1.0"]
                 [clj-time "0.12.0"]
                 [com.cognitect/transit-clj "0.8.288"]
                 [buddy/buddy-auth "1.2.0"]
                 [crypto-password "0.2.0"]

                 ;; cljs
                 [org.clojure/clojurescript "1.9.229"]
                 [org.omcljs/om "1.0.0-alpha44"]
                 [cljsjs/react-bootstrap "0.30.2-0" :exclusions [org.webjars.bower/jquery]]
                 [cljsjs/moment "2.10.6-4"]
                 [com.cognitect/transit-cljs "0.8.239"]
                 [bidi "2.0.10"]]

  :plugins [[lein-cljsbuild "1.1.4"]
            [lein-figwheel "0.5.7"]
            [cider/cider-nrepl "0.13.0"]]

  :source-paths ["src/clj" "src/cljs"]

  :test-paths ["test/clj" "test/cljs"]

  :resource-paths ["resources"]

  :main net.svard.timeclock

  :clean-targets ^{:protect false} ["resources/public/js/compiled" "target"]

  :cljsbuild {:builds [{:id "dev"
                        :source-paths ["src/cljs"]
                        :figwheel {:on-jsload "net.svard.timeclock/on-js-reload" }
                        :compiler {:main net.svard.timeclock
                                   :asset-path "js/compiled/out"
                                   :output-to "resources/public/js/compiled/index.js"
                                   :output-dir "resources/public/js/compiled/out"
                                   :source-map-timestamp true
                                   :parallel-build true}}
                       {:id "min"
                        :source-paths ["src/cljs"]
                        :compiler {:output-to "resources/public/js/compiled/index.js"
                                   :main net.svard.timeclock
                                   :optimizations :advanced
                                   :externs ["src/js/momentjs-extra.js"]
                                   :pretty-print false
                                   :parallel-build true}}]}

  :profiles
  {:dev {:dependencies [[com.cemerick/piggieback "0.2.1"] 
                        [org.clojure/tools.nrepl "0.2.12"]
                        [refactor-nrepl "2.2.0"]]}
   :uberjar {:aot [net.svard.timeclock]
             :prep-tasks ["compile" ["cljsbuild" "once" "min"]]}}

  :figwheel {
             ;; :http-server-root "public" ;; default and assumes "resources" 
             ;; :server-port 3449 ;; default
             ;; :server-ip "127.0.0.1" 

             :css-dirs ["resources/public/css", "resources/public/css/compiled"] ;; watch and update CSSb

             ;; Start an nREPL server into the running figwheel process
             :nrepl-port 7888

             :nrepl-middleware ["cider.nrepl/cider-middleware"
                                "refactor-nrepl.middleware/wrap-refactor"
                                "cemerick.piggieback/wrap-cljs-repl"]})
