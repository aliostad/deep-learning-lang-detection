(ns om-tutorial.actions
  (:require [clojure.string :as str]
            [om-tutorial.syncer :as syncer]
            [re-frame.core :refer [dispatch
                                   dispatch-sync]]
            [cljs.core.async :as a
             :refer [>! <! chan buffer close!
                     alts! timeout]]
            [om-tutorial.api :as api]
            [om-tutorial.config :as config])
  (:require-macros
   [cljs.core.async.macros :refer [go go-loop]]))

(defn log-in [api-config]
  (api/log-in api-config))

(defn sync-config [api-config]
  (assoc config/sync-base :api api-config))

(defn stop-searching [sync-status]
  (swap! (:stop sync-status) not)
  (dispatch [:stopped-searching]))

(defn start-searching [api-config base-id]
  (let [sync-config (sync-config api-config)
        stop (atom false)
        people (syncer/crawl sync-config base-id)]
    (dispatch [:started-searching people stop])
    (go-loop [i 0]
      (let [person (<! people)]
        (if person
          (do
            (dispatch [:found-person person])
            (if (or (> i (:max-num sync-config))
                    @stop)
              (dispatch [:stopped-searching])
              (recur (inc i))))
          (dispatch [:stopped-searching]))))))
