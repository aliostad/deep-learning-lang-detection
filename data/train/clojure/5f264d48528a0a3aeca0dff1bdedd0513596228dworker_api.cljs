(ns cljsrn-re-frame-workers.worker-api
  (:require [cljsrn-re-frame-workers.worker-utils :as worker-utils]
            [re-frame.core]))

;;;;;;;  API  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; When in production pass all re-frame requests to the worker
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defonce use-worker? (atom false))

(defn dispatch [dispatch-v]
  (if @use-worker?
    (worker-utils/dispatch dispatch-v)
    (re-frame.core/dispatch dispatch-v)))

(defn dispatch-sync [dispatch-v]
  (if @use-worker?
    (worker-utils/dispatch-sync dispatch-v)
    (re-frame.core/dispatch-sync dispatch-v)))

(defn subscribe [sub-v]
  (if @use-worker?
    (worker-utils/subscribe sub-v)
    (re-frame.core/subscribe sub-v)))

(defn init-worker [worker-file ready-fn]
  (reset! use-worker? true)
  (worker-utils/init-worker worker-file ready-fn))