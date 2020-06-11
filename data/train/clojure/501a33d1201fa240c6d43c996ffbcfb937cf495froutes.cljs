(ns learn-specter.routes
  (:require [re-frame.core :refer [dispatch]]
            [bidi.bidi :as bidi]
            [pushy.core :as pushy]))

;; bidi works better for local development.
;; Use secretary for hashbang navigation when deployed.

(def routes
  ["/" {""                   :index
        ["page/" [long :id]] :page}])

(defn- dispatch-route [match]
  (case (:handler match)
    :index (dispatch [:show-page 0])
    :page (dispatch [:show-page (-> match :route-params :id)])))

(def history (pushy/pushy dispatch-route
                          (partial bidi/match-route routes)))

(defn init []
  (pushy/start! history))

(defn set-token! [token]
  (pushy/set-token! history token))

(defn path-for [tag & args]
  (apply bidi/path-for routes tag args))

(defn page-path
  [page]
  (path-for :page :id page))


;(ns learn-specter.routes
;  (:require-macros [secretary.core :refer [defroute]])
;  (:import goog.History)
;  (:require [secretary.core :as secretary]
;            [goog.events :as events]
;            [goog.history.EventType :as EventType]
;            [re-frame.core :refer [dispatch]]))
;
;(defn hook-browser-navigation! []
;  (doto (History.)
;    (events/listen
;      EventType/NAVIGATE
;      (fn [event]
;        (secretary/dispatch! (.-token event))))
;    (.setEnabled true)))
;
;(defn init []
;  (secretary/set-config! :prefix "#")
;  ;; --------------------
;  ;; define routes here
;  (defroute "/" [] (dispatch [:show-page 0]))
;
;  (defroute page-path "/page/:id" {id :id} (dispatch [:show-page (int id)]))
;
;  ;; --------------------
;  (hook-browser-navigation!))


