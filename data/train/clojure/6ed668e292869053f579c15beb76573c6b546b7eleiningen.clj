
;;;; ---------------------------------------------------------------------------
;;;; --------------   Building and Developing with Leiningen  ------------------
;;;; ---------------------------------------------------------------------------

;; Leiningen, the tool which we have been using thus far, is akin to Java's
;; Maven - or for what I use each day, JavaScript's Webpack/Gulp/Grunt.
;; At its core, Leiningen addresses the management of "artifacts," the executable
;; files or library packages that end up being deployed/shared. It also helps
;; us manage dependent artifacts, "dependencies," by ensuring they are loaded
;; in the project build. It can even enhance our local dev experience with
;; "plug-ins."

; -----------------------------------------------------------------------------
; The Artifact Ecosystem

;; The lingering history of Maven in the Java ecosystem carries over in the
;; pattern used by Leiningen and Maven for identifying artifacts that Clojure
;; projects adhere to, and it also specifies how to host these artifacts in
;; Maven "repositories," which are servers that store artifacts for distribution.

; -------------
; Identifaction
; -------------

;; Maven artifacts need a "group ID", an "artifact ID", and a "version"

;; Ex.
(defproject clojure-example "0.1.0-SNAPSHOT")

;; `clojure-example` is both the artifact and group ID, and `0.1.0-SNAPSHOT` the
;; version - using the `-SNAPSHOT` to signify we plan on updating this and
;; that it is a work in progress

; ------------
; Dependencies
; ------------

(:dependencies [[org.clojure/clojure "1.7.0"]
                [clj-time "0.9.0"]])

;; We add our dependencies to our vector using the same naming schema we used
;; for our identification section.

;; Dependencies in this vector are downloaded by Leiningen on next project start.

;; When you want to look for libraries, look here:
;;   http://www.clojure-toolbox.com
;;   https://clojars.org/
;;   http://search.maven.org/

;; To upload our own project to Clojars, we can run: `lein deploy clojars`

; --------
; Plug-Ins
; --------

;; Plug-ins are libraries that help us when we're writing code. For example,
;; the Eastwood plug-in is a Clojure linter. Before we start adding plug-ins,
;; we want to specify your plug-ins in the file $HOME/.lein/profiles.clj
;; To add Eastwood to our project, we'd update the `profiles.clj` like this:

{:user {:plugins [[jonase/eastwood "0.2.1"]] }}

;; This enables an `eastwood` Leiningen task for all projects, which we can
;; run with `lein eastwood` at the project's root.
