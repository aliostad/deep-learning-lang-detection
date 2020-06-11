(ns app.api
  (:require [om.next.server :as om]
            [om.next.impl.parser :as op]
            [taoensso.timbre :as timbre]))

(defmulti apimutate om/dispatch)
(defmulti api-read om/dispatch)

(defmethod apimutate :default [e k p]
  (timbre/error "Unrecognized mutation " k))

(defmethod api-read :default [{:keys [ast query] :as env} dispatch-key params]
  (timbre/error "Unrecognized query " (op/ast->expr ast)))

(defmethod api-read :child/by-id [{:keys [parser query] :as env} dispatch-key params]
  (timbre/info query)
  (when (= query [:long-query])
    {:value (parser env query)}))

(defmethod api-read :long-query [{:keys [ast query] :as env} dispatch-key params]
  (timbre/info "Long query started")
  (Thread/sleep 5000)
  (timbre/info "Long query finished")
  {:value 42})
