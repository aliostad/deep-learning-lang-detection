(ns theproject.routes
    (:require-macros [secretary.core :refer [defroute]])
    ;; (:import goog.History)
    (:require [secretary.core :as secretary]
              ;; [goog.events :as events]
              ;; [goog.history.EventType :as EventType]
              [re-frame.core :as re-frame]
              [pushy.core :as pushy]
              ))


;; (defn hook-routes-with-octothorp-prefix []
;;   (secretary/set-config! :prefix "#")    ; should this line go before defroutes? never mind, it works here
;;   (doto (History.)
;;     (events/listen
;;      EventType/NAVIGATE
;;      (fn [event]
;;        (secretary/dispatch! (.-token event))))
;;     (.setEnabled true)))

(defonce history (pushy/pushy secretary/dispatch! (fn [x] (when (secretary/locate-route x) x))))
(defn hook-routes []
  (secretary/set-config! :prefix "/")
  (pushy/start! history)
  )


(defn app-routes []
  
  (defroute "/" []
    (re-frame/dispatch [:set-active-panel :home-panel]))

  (defroute "/about" []
    (re-frame/dispatch [:set-active-panel :about-panel]))

  (defroute "/card/:card_id" [card_id]
    (re-frame/dispatch [:set-active-panel [:card-panel card_id]]))

  (defroute "/deck/:deck_id" [deck_id]
    (re-frame/dispatch [:set-active-panel [:deck-panel deck_id]]))
  

  ;; (hook-routes-with-octothorp-prefix)
  (hook-routes)
  )
