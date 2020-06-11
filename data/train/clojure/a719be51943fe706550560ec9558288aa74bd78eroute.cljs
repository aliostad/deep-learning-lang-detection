(ns user-reports.route
  (:require [bidi.bidi :as bidi]
            [pushy.core :as pushy]
            [re-frame.core :as rf]))

(def routes ["/app" {"" :index
                     ["/ticket/" :id] :ticket}])

(defn dispatch-route [match]
  (case (:handler match)
    :index (rf/dispatch [:index])
    :ticket (rf/dispatch [:ticket (-> match :route-params :id)])))

(def match-route (partial bidi/match-route routes))

(defn path-for [handler & params]
  (apply bidi/path-for routes handler params))

(def history (pushy/pushy dispatch-route match-route))

(defn init []
  (pushy/start! history))
