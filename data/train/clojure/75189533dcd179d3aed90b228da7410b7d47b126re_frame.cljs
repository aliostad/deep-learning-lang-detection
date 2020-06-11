(ns mex.re-frame
  (:require-macros [mex.macros.core :refer [def-let]])
  (:require [mex.state.core :as state]
            [re-frame.core :as re-frame]
            [re-frame.middleware :as middleware]))

(let [app (re-frame/app [:mex] state/app-state middleware/pure (when goog.DEBUG
                                                                middleware/debug-monitor))]
  (def topic (:topic app))
  (def subscribe (:subscribe app))
  (def clear-topics! (:clear-topics! app))
  (def dispatch (:dispatch app))
  (def dispatch-sync (:dispatch-sync app))
  (def handler (:handler app))
  (def handler! (:handler! app))
  (def clear-handlers! (:clear-handlers! app))
  (def set-loggers! (:set-loggers! app)))

(def no-op (fn [db _] db))
