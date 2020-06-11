(defproject scarab "0.1.0-SNAPSHOT"
  :description "Manage translating a collection of Markdown files"
  :url "http://github.com/plexus/scarab"
  :license {:name "Mozilla Public License"
            :url "https://www.mozilla.org/en-US/MPL/2.0/"}

  :dependencies [[org.clojure/clojure "1.7.0"]
                 [org.clojure/clojurescript "1.7.122"]
                 [org.clojure/core.async "0.1.346.0-17112a-alpha"]
                 [clj-jgit "0.8.8"]
                 [endophile "0.1.2"]
                 [compojure "1.4.0"]
                 [enlive "1.1.6"]
                 [org.omcljs/om "0.9.0"]
                 [http-kit "2.2.0-SNAPSHOT"]
                 [org.clojure/google-closure-library "0.0-20150805-acd8b553"]
                 [ring "1.4.0"]
                 [org.clojure/data.json "0.2.6"]
                 [garden "1.3.0-SNAPSHOT"]
                 [facjure/mesh "0.4.0"]
                 [sablono "0.3.6"]
                 [com.cognitect/transit-cljs "0.8.225"]]

  :plugins [[lein-cljsbuild "1.1.0"]
            [lein-figwheel "0.4.0"]
            [lein-garden "0.2.6"]]

  :source-paths ["src/clj"]

  :clean-targets ^{:protect false} ["resources/public/js/compiled"
                                    "resources/public/css/compiled"
                                    "target"]

  :cljsbuild {
    :builds [{:id "dev"
              :source-paths ["src/cljs"]

              :figwheel { :on-jsload "scarab.core/on-js-reload" }

              :compiler {:main scarab.core
                         :asset-path "js/compiled/out"
                         :output-to "resources/public/js/compiled/scarab.js"
                         :output-dir "resources/public/js/compiled/out"
                         :source-map-timestamp true }}
             {:id "min"
              :source-paths ["src/cljs"]
              :compiler {:output-to "resources/public/js/compiled/scarab.js"
                         :main scarab.core
                         :optimizations :advanced
                         :pretty-print false}}]}

  :figwheel {
             ;; :http-server-root "public" ;; default and assumes "resources"
             ;; :server-port 3449 ;; default
             ;; :server-ip "127.0.0.1"

             :css-dirs ["resources/public/css"] ;; watch and update CSS

             ;; Start an nREPL server into the running figwheel process
             :nrepl-port 7888

             :nrepl-middleware ["cider.nrepl/cider-middleware"
                                "refactor-nrepl.middleware/wrap-refactor"
                                "cemerick.piggieback/wrap-cljs-repl"]

             ;; Server Ring Handler (optional)
             ;; if you want to embed a ring handler into the figwheel http-kit
             ;; server, this is for simple ring servers, if this
             ;; doesn't work for you just run your own server :)
             :ring-handler scarab.core/ring-handler

             ;; To be able to open files in your editor from the heads up display
             ;; you will need to put a script on your path.
             ;; that script will have to take a file path and a line number
             ;; ie. in  ~/bin/myfile-opener
             ;; #! /bin/sh
             ;; emacsclient -n +$2 $1
             ;;
             ;; :open-file-command "myfile-opener"

             ;; if you want to disable the REPL
             ;; :repl false

             ;; to configure a different figwheel logfile path
             ;; :server-logfile "tmp/logs/figwheel-logfile.log"
             }

  :garden {:builds [{;; Optional name of the build:
                     :id "screen"
                     ;; Source paths where the stylesheet source code is
                     :source-paths ["src/clj"]
                     ;; The var containing your stylesheet:
                     :stylesheet scarab.styles/screen
                     ;; Compiler flags passed to `garden.core/css`:
                     :compiler {;; Where to save the file:
                                :output-to "resources/public/css/compiled/screen.css"
                                ;; Compress the output?
                                :pretty-print? false}}]})
