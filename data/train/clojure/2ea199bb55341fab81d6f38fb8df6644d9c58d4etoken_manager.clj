(ns dialog-play-bot-for-layer.component.token-manager
  "Manage yepl access-token, dialog-play channel-id, layer conversation-id."
  (:require [integrant.core :as ig]
            [clojure.core.cache :as cache]))

(defprotocol ITokenManager
  (new-conversation [this layer-conversation-id dialog-play-channel-id])
  (get-dialog-play-channel-id [this layer-conversation-id])
  (register-yelp-access-token [this yelp-access-token])
  (get-yelp-access-token [this]))

(defrecord TokenManager []
  ITokenManager
  (new-conversation [this layer-conversation-id dialog-play-channel-id]
    (let [conversation-cache (:conversation-cache this)]
      (swap! conversation-cache assoc-in [layer-conversation-id]
             dialog-play-channel-id)))
  (get-dialog-play-channel-id [this layer-conversation-id]
    (let [conversation-cache (:conversation-cache this)]
      (cache/lookup @conversation-cache layer-conversation-id)))
  (register-yelp-access-token [this yelp-access-token]
    (let [conversation-cache (:conversation-cache this)]
      (swap! conversation-cache assoc "yelp-access-token" yelp-access-token)))
  (get-yelp-access-token [this]
    (let [conversation-cache (:conversation-cache this)]
      (cache/lookup @conversation-cache "yelp-access-token"))))

(defmethod ig/init-key :dialog-play-bot-for-layer.component/token-manager [_ opts]
  (assoc (map->TokenManager opts)
         :conversation-cache (atom (cache/ttl-cache-factory {} :ttl (* 10 60 1000)))
         :yelp-access-token-cache (atom (cache/ttl-cache-factory {} :ttl (* 10 60 1000)))))

(defmethod ig/resume-key :dialog-play-bot-for-layer.component/token-manager [_ opts _ _]
  (assoc (map->TokenManager opts)
         :conversation-cache (atom (cache/ttl-cache-factory {} :ttl (* 10 60 1000)))
         :yelp-access-token-cache (atom (cache/ttl-cache-factory {} :ttl (* 10 60 1000)))))

(defmethod ig/halt-key! :dialog-play-bot-for-layer.component/token-manager [_ opts])
