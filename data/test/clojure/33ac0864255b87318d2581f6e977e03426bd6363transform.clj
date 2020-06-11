(ns trace-playground.transform
  (:use
    [lamina core])
  (:require
    [lamina.trace :as trace]
    [clojure.tools.logging :as log]
    [sleight.core :as sleight]
    [sleight.walk :as walk]))

;;;

(def captured (atom []))

(defn captured-traces
  "Returns traces for all functions that have been called so far."
  []
  @captured)

(defn init-capture []
  (receive-all
    (remove*
      (fn [_] (trace/tracing?))
      (trace/select-probes "*:return"))
    #(swap! captured conj %)))

;;;

(def expr-handlers
  (update-in walk/expr-handlers [#'defn]
    (fn [defn-handler]
      (fn [handlers form]
        (let [form (defn-handler handlers form)]
          (with-meta
            (list* 'lamina.trace/defn-instrumented (rest form))
            (meta form)))))))

(sleight/def-transform instrument
  :pre (fn []
         (require 'lamina.trace)
         (require 'sleight.walk)
         (init-capture))
  :transform #(walk/walk-exprs expr-handlers %))
