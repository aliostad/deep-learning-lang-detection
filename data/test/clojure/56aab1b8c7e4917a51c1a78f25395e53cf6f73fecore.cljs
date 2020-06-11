(ns clchess.core
  (:require-macros [secretary.core :refer [defroute]])
  (:require [reagent.core :as reagent :refer [atom]]
            [re-frame.core :refer [subscribe dispatch dispatch-sync]]
            [secretary.core :as secretary]
            [goog.events :as events]
            [clchess.utils :as utils]
            [clchess.board :as board]
            [clchess.events] ;; Do not remove this. This is needed for handler registration
            [clchess.subs] ;; Do not remove this. This is needed for subscription handler registration
            [clchess.views]
            [taoensso.timbre :as log])
  (:import [goog History]
           [goog.history EventType]))

;; -- Routes and History ------------------------------------------------------

;; (defroute "/" [] (dispatch [:set-showing :all]))
;; (defroute "/:filter" [filter] (dispatch [:set-showing (keyword filter)]))

(def history
  (doto (History.)
    (events/listen EventType.NAVIGATE
                   (fn [event] (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

;; -------------------------
;; Initialize app
;; -------------------------

(defn mount-root []
  (reagent/render [clchess.views/clchess-app] (utils/by-id "app")))

(defn listen-to-events []
  (log/debug "listen-to-events")
  (.addEventListener js/window "resize"
                     #(dispatch [:view/resized]))
  (utils/fullscreen-change #(dispatch [:view/fullscreen-changed %])))

(def pre-render-hook nil)

(defn reset-page []
  (dispatch-sync [:theme/initialize @(subscribe [:theme])])
  (dispatch-sync [:game/update-board])
  (doseq [func pre-render-hook]
    (func))
  (mount-root)
  (listen-to-events))

(def page-load-hook nil)

(defn init! []
  (dispatch-sync [:initialise-db])
  (log/debug "Executing page load hooks")
  (doseq [func page-load-hook]
    (func))

  (reset-page))
