#!/usr/bin/env boot

#tailrecursion.boot.core/version "2.4.0"

(set-env!
  :project 'repl
  :version "0.1.0-SNAPSHOT"
  :dependencies '[[tailrecursion/boot.task "2.2.1"]
                  [tailrecursion/hoplon "5.10.1"]
                  [tailrecursion/boot.ring "0.1.0"]
                  [org.clojure/clojurescript "0.0-2227"]]
  :out-path "public"
  :src-paths #{"src"})

(require
  '[tailrecursion.boot.task :refer :all]
  '[tailrecursion.hoplon.boot :refer :all]
  '[tailrecursion.boot.task.ring :as ring]
  '[pmbauer.boot.task.repl :as repl]
  '[pmbauer.boot.task.cljs :as cljs])

(deftask brepl
  "launch browser repl, default point browser to public/index.html"
  [& [index-file]]
  (comp (ring/files)
        (ring/jetty)                 ;; serve static files from "public"
        (cljs/+ :browser)            ;; add cljs repl middlewares
        (repl/repl :pass-through)    ;; start headless repl in pass-through mode
        (watch)
        (hoplon)
        (cljs/+brepl (or index-file "index.html")) ;; args are list of artifacts to instrument with brepl connect script
        ))
