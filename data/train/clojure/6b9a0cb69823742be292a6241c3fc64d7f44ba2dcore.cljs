(ns rex.core
  (:require [rex.reducer :as rc]
            [rex.middleware :as mw]
            [rex.dispatch :as dpt]
            [rex.watcher :as swt]))

(defonce *store-init-value* {})
(defonce store (atom *store-init-value*))

(defn reset-store! []
  (reset! store *store-init-value*))

(defn- get-store []
  @store)

(defn- update-store [fn]
  (swap! store fn))

(defn dispatch [action]
  (dpt/dispatch get-store
                update-store
                rc/get-reducers
                swt/get-watchers
                mw/get-middlewares
                action))
