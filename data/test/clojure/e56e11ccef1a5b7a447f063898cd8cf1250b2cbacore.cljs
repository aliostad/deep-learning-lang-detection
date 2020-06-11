(ns kokugakuinsumo.core
  (:require [reagent.core :as reagent]
            [secretary.core :as secretary :include-macros true]
            [accountant.core :as accountant]
            [re-frame.core :refer [register-handler
                                   path
                                   register-sub
                                   dispatch
                                   dispatch-sync
                                   subscribe]]
            [kokugakuinsumo.handlers]
            [kokugakuinsumo.subscriptions]
            [kokugakuinsumo.database]
            [kokugakuinsumo.views.app :refer [app]]))

(secretary/defroute "/" []
  (dispatch [:set-current-page :top-page]))
(secretary/defroute "/about" []
  (dispatch [:set-current-page :about-page]))
(secretary/defroute "/linklist" []
  (dispatch [:set-current-page :linklist-page]))
(secretary/defroute "/mail" []
  (dispatch [:set-current-page :mail-page]))
(secretary/defroute "/member" []
  (dispatch [:set-current-page :member-page]))
(secretary/defroute "/photo" []
  (dispatch [:set-current-page :photo-page]))
(secretary/defroute "/record" []
  (dispatch [:set-current-page :record-page]))
(secretary/defroute "/schedule" []
  (dispatch [:set-current-page :schedule-page]))

(defn mount-root []
  (reagent/render [app] (.getElementById js/document "app")))

(defn init! []
  (accountant/configure-navigation!
    {:nav-handler (fn [path] (secretary/dispatch! path))
     :path-exists? (fn [path] (secretary/locate-route path))})
  (accountant/dispatch-current!)
  (dispatch-sync [:initialize])
  (mount-root))

(defn ^:export main []
  (init!))
