(ns inside-out.10-integration)
(set! *print-length* 7)

;;;; Integration
;; the clojure eco system

;;;; Leiningen
;; create new projects
;; manage dependencies for your project
;; run tests
;; run ar REPL (without you having to worry about adding dependencies to the classpath)
;; run the project (if the project is an app)
;; generate a maven-style "pom" file for the project
;; compile and package projects for deployment
;; publish libraries to maven artifact repositories such as Clojars
;; run custom automation tasks written in Clojure (leiningen plug-ins)

;; Java: "Maven meets Ant (without the pain)"
;; Ruby: RubyGems/Bundler/Rake
;; Python: pip/fabric

;;;; IDE's
;; Eclipse + Counterclockwise
;; Emacs .. emacs-starter-kit

;;;; Ring 
;;;; Compojure
(comment

  (ns hello-world
    (:use compojure.core)
    (:require [compojure.route :as route]))
  (defroutes app
    (GET "/" [] "<h1>Hello World</h1>")
    (route/not-found "<h1>Page not found</h1>"))

)

;;;; Hiccup - html generation

;;;; Clojure Contrib Libraries
;; http://dev.clojure.org/display/doc/Clojure+Contrib+Libraries

;;;;
;;;; 4clojure
;;;; himera
;;;; Incanter
;;;; Storm -- distributed realtime computation system (similar to Hadoop)
;;;; Pedestal (pedestal.io) 

;;;; Datomic
;; 15:05
;; data is shipped around using 'edn'
;; 16:47 Demo starts
;; "day of datomic"
;; universal relation database. one relation: the entity (37:00)

;;;; the end
