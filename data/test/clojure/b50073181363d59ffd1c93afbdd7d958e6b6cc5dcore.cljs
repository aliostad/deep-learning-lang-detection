(ns examples.async.core
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [cljs.core.async :refer [<! timeout]]
            [celeriac.core :as celeriac]
            [celeriac.dev :refer [repl-connect!]]))

(enable-console-print!)

;; --------------------------------------------------
;; Handlers

(defmulti handler
  (fn [state action]
    (first action)))

(defmethod handler :foo
  [state [_ value]]
  (assoc state :foo value))

(defmethod handler :bar
  [state [_ value]]
  (assoc state :bar value))

;; --------------------------------------------------
;; Actions

(defn foo [value]
  [:foo value])

;; Async actions are a function that accepts
;; a dispatch function
(defn bar [value]
  (fn [dispatch]
    (dispatch [:bar value])
    (go
      (<! (timeout 1000))
      (dispatch (bar value)))))

;; --------------------------------------------------
;; Main

(def store (celeriac/create-store handler))

(celeriac/subscribe store
                    (fn [action before after]
                      (println "---")
                      (println "state:" before)
                      (println "action:" action)
                      (println "state:" after)))

(celeriac/dispatch! store (foo "baz"))
(celeriac/dispatch! store (bar "qux"))

;; Dev
#_(repl-connect!)
