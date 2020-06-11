(ns app.effect
  (:require-macros [cljs.core.async.macros :refer [go go-loop]])
  (:require [cljs.core.async :as async]
            [app.db :as db]
            [app.routing :as routing]
            [app.logger :as log]
            [app.platform :as platform]))

(defonce events (async/chan))

(defn emit! [events n & params]
  (async/put! events (into [n] params)))

(def navigate ::navigate)
(def back ::back)

(def notification ::notification)

(defmulti dispatch! (fn [n & more] n))

(defmethod dispatch! navigate [_ route & [params :as opts]]
  (swap! db/state update ::db/nav routing/navigate route params))

(defmethod dispatch! back [_]
  (swap! db/state update ::db/nav routing/back))

(defmethod dispatch! notification [_]
  ((aget platform/expo "Notifications" "presentLocalNotificationAsync") #js {:title "John Doe" :body "Hey I've been trying to call you"}))
