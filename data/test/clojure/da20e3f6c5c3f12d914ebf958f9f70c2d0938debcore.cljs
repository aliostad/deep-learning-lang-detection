(ns raiseyourgame.core
  (:require [reagent.core :as reagent :refer [atom]]
            [re-frame.core :refer [dispatch dispatch-sync]]
            [secretary.core :as secretary]
            [ajax.core :refer [GET POST]])
  (:require-macros [reagent.ratom :refer [reaction]]
                   [secretary.core :refer [defroute]])
  (:import [goog History]
           [goog.history EventType]))

(def app-db (atom {}))

(defn main-view []
  (fn []
    [:div
     [:h1 "Hi! This is the main app."]]))

(defn main []
  (dispatch-sync [:initialize-db])
  (reagent/render [main-view]
                  (.getElementById js/document "app")))

(main)
