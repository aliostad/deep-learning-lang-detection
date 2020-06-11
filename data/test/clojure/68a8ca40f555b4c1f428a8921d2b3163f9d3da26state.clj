(ns server.state
    (:require [clojure.core.async :refer [<! go-loop timeout chan]])
    (:require [server.api.jgi-gateway :as jgi-gateway]))


;; The state namespace is used to create and manage a globally available
;; sense of application state -- an app database if you will.

;; What is it?

;; Simply a single atom.

;; I don't know that we need a separate ns/module for this, but 
;; we may need some common functions, so leave in place for now.

;; Jobs are, for now, simply a map of job id to some structure.
;; Stored in an atom because we expect concurrent access.
(defn make-state
    []
    (atom {}))

