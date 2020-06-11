(ns app.routes
  (:require-macros [app.logging :refer [log]])
  (:require [bidi.bidi :as bidi]
            [pushy.core :as pushy]
            [re-frame.core :as re-frame]))

(def routes ["/" { "" :home
                  [""  [keyword :game-id]] :game}])

(defn- parse-url [url]
  (bidi/match-route routes url))

(defn- dispatch-route [match]
  (case (:handler match)
    :home (re-frame/dispatch [:current-page :home])
    :game (re-frame/dispatch [:current-page :game])))

(def history (pushy/pushy dispatch-route (partial bidi/match-route routes)))

(defn start! []
  (pushy/start! history))

(defn set-token! [token]
  (pushy/set-token! history token))

(defn get-token [] (pushy/get-token history))

(defn path-for [tag & args]
  (apply bidi/path-for routes tag args))
