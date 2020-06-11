(ns bgg.routes
  (:require [bidi.bidi :as bidi]
            [pushy.core :as pushy]
            [re-frame.core :as re-frame]))

(def routes ["/" {""      :home
                  "about" :about}])

(defn- dispatch-route [matched-route]
  (let [panel-name (keyword (str (name (:handler matched-route)) "-panel"))]
    (re-frame/dispatch [:set-active-panel panel-name])))

(defn- parse-url [url]
  (bidi/match-route routes url))

(defn app-routes []
  (pushy/start! (pushy/pushy dispatch-route parse-url)))

(def route (partial bidi/path-for routes))
