(ns jiksnu.channels
  (:require [manifold.bus :as bus]
            [manifold.stream :as s]))

(defonce events (bus/event-bus))

;; async fetchers

(defonce pending-get-conversation
  (s/stream*
   {:permanent? true
    :description "pending-get-conversation"}))

(defonce pending-get-discovered
  (s/stream*
   {:permanent? true
    :description "pending-get-discovered"}))

(defonce pending-get-domain
  (s/stream*
   {:permanent? true
    :description "pending-get-domain"}))

(defonce pending-get-resource
  (s/stream*
   {:permanent? true
    :description "pending-get-resource"}))

(defonce pending-get-source
  (s/stream*
   {:permanent? true
    :description "pending-get-source"}))

(defonce pending-create-conversations
  (s/stream*
   {:permanent? true
    ;; :description "pending-create-conversations"
    }))

(defonce pending-create-stream
  (s/stream*
   {:permanent? true
    :description "pending-create-stream"}))

(defonce pending-update-resources
  (s/stream*
   {:permanent? true
    :description "pending-update-resources"}))

(defonce pending-updates
  (s/stream*
   {:permanent? true
    :description "Channel containing list of sources to be updated"}))

(defonce pending-entries
  (s/stream*
   {:permanent? true
    :description "All atom entries that are seen come through here"}))

(defonce posted-activities
  (s/stream*
   {:permanent? true
    :grounded? true
    :description "Channel for newly posted activities"}))

(defonce posted-conversations
  (s/stream*
   {:permanent? true
    :grounded? true
    :description "Channel for newly posted conversations"}))

(defonce pending-get-user-meta
  (s/stream*
   {:permanent? true
    :description "get-user-meta"}))

(defonce pending-new-subscriptions
  (s/stream*
   {:permanent? true
    :description "pending-new-subscriptions"}))
