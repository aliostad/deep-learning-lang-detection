(ns mud.dispatch
  (:require [mud.server.state :as ss]
            [mud.db.core :as mc]
            [mud.query :as mq]))

(defmulti dispatch (fn [input uid] (:type input)))

(defmethod dispatch :default
  [_ _]
  (rand-nth (get ss/canned-responses :que?)))

;; echo only on client?
;(defmethod dispatch :toggle-phrase
;  [{:keys [flag state]} uid]
;  (swap! world assoc flag ({:off false :on true} state))
;  (get-in (:canned-responses @world) [flag state]))

(defmethod dispatch :direction
  [{direction :value} uid]
  (mq/move mc/conn [:player/name uid] (keyword "edge" (name direction)))
  (mq/look mc/conn [:player/name uid]))
