(ns exposure.routes
  (:require [taoensso.timbre :as log :include-macros true]
            [re-frame.core :refer [dispatch]]

            [bidi.bidi :as bidi]
            [pushy.core :as pushy]))

(log/debug "Registering routes")

(def routes ["/" {""        :home-page
                  "about"   :about-page
                  "profile" :profile-page
                  "privacy" :privacy-page}])

(defn- parse-url [url]
  (bidi/match-route routes url))

(defn- dispatch-route [matched-route]
  (let [{handler :handler} matched-route]
    (dispatch [:set-active-page handler])))

(defn init-routes []
  (log/debug "Initializing routes")
  (pushy/start! (pushy/pushy dispatch-route parse-url)))

(def url-for (partial bidi/path-for routes))