(ns stream-of-redditness.dispatch
  (:require [datival.core :as dv]
            [stream-of-redditness.events :as e]
            [stream-of-redditness.config :as c]))

(let [{:keys [dispatch
              dispatch-sync
              get-state]} (->> c/event-config
                               e/stream-of-redditness-events
                               (dv/make-event-system
                                false                       ;; c/debug?
                                ))]
  (def dispatch dispatch)
  (def dispatch-sync dispatch-sync)
  (def get-state get-state))
