(ns pianolo.routes
  (:require [bidi.bidi :as bidi]
            [goog.events :as ev]
            [re-frame.core :as re])
  (:import [goog History]))

(defonce h (History.))
(.setEnabled h true)

(def routes ["/" {""                    :index
                  [[keyword :filter]]   :filter}])

(defonce navigate-listener
  (ev/listen h goog.history.EventType.NAVIGATE
    (fn [e x]
      (when-let [route (bidi/match-route routes (.-token e))]
        (re/dispatch [:set-showing (get-in route [:route-params :filter])])))))




















;(def routes
;  ["/console/" {"" :cards
;                ["card/" [keyword :card-id]] :card}])
;
;(defn- dispatch-route [match]
;  (case (:handler match)
;    :cards (re-frame/dispatch [:show-all-cards])
;    :card (re-frame/dispatch [:card-click (-> match :route-params :card-id)])))
;
;(def history (pushy/pushy dispatch-route (partial bidi/match-route routes)))
;
;(defn init []
;  (pushy/start! history))
;
;(defn set-token! [token]
;  (pushy/set-token! history token))
;
;(defn path-for [tag & args]
;  (apply bidi/path-for routes tag args))
;
;(def app-routes ["/" {"index" :index}])
;  ;;(dispatch [:set-showing :all]))



;(defroute "/" [] (dispatch [:set-showing :all]))
;(defroute "/:filter" [filter] (dispatch [:set-showing (keyword filter)]))