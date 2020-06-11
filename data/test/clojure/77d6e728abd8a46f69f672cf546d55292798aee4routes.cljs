(ns games.routes
  (:require
   [re-frame.core :as rf]
   [bidi.bidi :as bidi]
   [pushy.core :as pushy]))

(def routes
  ["/" {""         :games
        "tzolkin/" {""         :tzolkin}
                   [:id] :tzolkin-game}])

(defn- parse-url [url]
  (bidi/match-route routes url))

(defn- dispatch-route [matched-route]
  (rf/dispatch [:navigate-to (:handler matched-route) (:route-params matched-route)]))

(defn setup!
  []
  (pushy/start! (pushy/pushy dispatch-route parse-url)))

(def url (partial bidi/path-for routes))
