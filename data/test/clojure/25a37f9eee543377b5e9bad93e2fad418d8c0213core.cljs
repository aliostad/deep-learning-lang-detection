(ns bfa-show.core
    (:require [re-frame.core :refer [register-handler
                                     path
                                     register-sub
                                     dispatch
                                     dispatch-sync
                                     subscribe]]
              [secretary.core :as secretary :include-macros true]
              [reagent.core :as reagent]
              [bfa-show.views :as views]
              [bfa-show.handlers]
              [bfa-show.subs]
              [bfa-show.graphics :as g]
              [accountant.core :as accountant]))

;; -------------------------
;; Routes

(secretary/defroute "/" []
  (dispatch [:set-page :home]))

(secretary/defroute "/colophon" []
  (dispatch [:set-page :colophon]))

(secretary/defroute "/nodes" []
  (dispatch [:set-page :nodes]))

;; -------------------------
;; Initialize app

(defn mount-root []
  (reagent/render [views/render] (.getElementById js/document "app")))

(defn init []
  (enable-console-print!)
  (println "init has been called")
  (accountant/configure-navigation!)
  (accountant/dispatch-current!)
  (dispatch-sync [:initialize-db])
  (mount-root)
  (g/init))

(init)

