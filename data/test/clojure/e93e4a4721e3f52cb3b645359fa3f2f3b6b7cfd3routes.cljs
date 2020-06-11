(ns coding-challenges.routes
    (:require-macros [secretary.core :refer [defroute]])
    (:import goog.History)
    (:require [secretary.core :as secretary]
              [goog.events :as events]
              [goog.history.EventType :as EventType]
              [re-frame.core :as rf]))

(defn hook-browser-navigation! []
 (doto (History.)
  (events/listen
   EventType/NAVIGATE
   (fn [event]
    (secretary/dispatch! (.-token event))))
  (.setEnabled true)))

(defn app-routes []
 (secretary/set-config! :prefix "#")
 ;; --------------------
 ;; define routes here
 (defroute "/" []
  (rf/dispatch [:set-active-panel :home-panel]))

 (defroute "/starfield" []
  (rf/dispatch [:set-active-panel :starfield-panel]))

 (defroute "/menger-sponge-fractal" []
  (rf/dispatch [:set-active-panel :menger-sponge-fractal-panel]))

 (defroute "/snake-game" []
  (rf/dispatch [:set-active-panel :snake-game-panel]))

 (defroute "/purple-rain" []
  (rf/dispatch [:set-active-panel :purple-rain-panel]))

 (defroute "/space-invaders" []
  (rf/dispatch [:set-active-panel :space-invaders-panel]))

 (defroute "/mitosis" []
  (rf/dispatch [:set-active-panel :mitosis-panel]))

 (defroute "/solar-system" []
  (rf/dispatch [:set-active-panel :solar-system-panel]))

 (defroute "/solar-system-3d" []
  (rf/dispatch [:set-active-panel :solar-system-3d-panel]))

 (defroute "/maze-generator" []
  (rf/dispatch [:set-active-panel :maze-generator-panel]))

 (defroute "/about" []
  (rf/dispatch [:set-active-panel :about-panel]))


 ;; --------------------
 (hook-browser-navigation!))
