(ns space-rpg.core
  (:require [accountant.core :as accountant]
            [re-frame.core :refer [subscribe dispatch-sync dispatch]]
            [reagent.core :as reagent :refer [atom cursor]]
            [reagent.session :as session]
            [secretary.core :as secretary :include-macros true]
            [space-rpg.subs]
            [space-rpg.handlers]
            [space-rpg.views])
  (:require-macros [reagent.ratom :refer [reaction]]))

;; -------------------------
;; Views

(defn current-page []
  [:div [(session/get :current-page)]])

;; -------------------------
;; Routes

(secretary/defroute "/" []
  (session/put! :current-page #'space-rpg.views/root))

;; -------------------------
;; Initialize app

(defn mount-root []
  (reagent/render [current-page] (.getElementById js/document "app")))

(defn init! []
  (accountant/configure-navigation!)
  (accountant/dispatch-current!)
  (dispatch-sync [:initialize-db])
  (mount-root))
