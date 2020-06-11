(ns jiksnu.modules.core.channels
  (:require [manifold.stream :as s]))

;; async fetchers

(defonce pending-get-conversation     (s/stream* {:permanent? true}))
(defonce pending-get-discovered       (s/stream* {:permanent? true}))
(defonce pending-get-domain           (s/stream* {:permanent? true}))
(defonce pending-get-resource         (s/stream* {:permanent? true}))
(defonce pending-get-source           (s/stream* {:permanent? true}))
(defonce pending-create-conversations (s/stream* {:permanent? true}))
(defonce pending-create-stream        (s/stream* {:permanent? true}))
(defonce pending-update-resources     (s/stream* {:permanent? true}))
(defonce pending-updates              (s/stream* {:permanent? true}))
(defonce pending-entries              (s/stream* {:permanent? true}))
(defonce posted-activities            (s/stream* {:permanent? true}))
(defonce posted-conversations         (s/stream* {:permanent? true}))
(defonce pending-get-user-meta        (s/stream* {:permanent? true}))
(defonce pending-new-subscriptions    (s/stream* {:permanent? true}))
