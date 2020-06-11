(ns us.edwardstx.auth.core
    (:require [reagent.core :as reagent :refer [atom]]
              [us.edwardstx.auth.handlers :as handlers]
              [us.edwardstx.auth.subs :as subs]
              [us.edwardstx.auth.views :as v]
              [secretary.core :as secretary :include-macros true]
              [re-frame.core :as re-frame]
              [accountant.core :as accountant]))

;; -------------------------
;; Views

(defn main-panel []
  (let [page (re-frame/subscribe [:page])
        user (re-frame/subscribe [:user])]
    (fn []
      (cond
        (or (= @page :loading) (= @user :none)) [:div {:class "loader"}]
        (= @page :whoami) [v/whoami user]
        :else [v/login-page #(re-frame/dispatch [:login %])]))))

;; -------------------------
;; Routes

(secretary/defroute "/auth/about" []
  (re-frame/dispatch [:navigate :about]))

(secretary/defroute "/auth/whoami" []
 (re-frame/dispatch [:navigate :whoami]))

(secretary/defroute "/auth/" []
  (re-frame/dispatch [:navigate :root]))

;; -------------------------
;; Initialize app

(def accountant-configuration
  {:nav-handler
   (fn [path] (secretary/dispatch! path))
   :path-exists?
   (fn [path] (secretary/locate-route path))})

(defn ^:export init! []
  (accountant/configure-navigation! accountant-configuration)
  (re-frame/dispatch-sync [:initialize])
  (accountant/dispatch-current!)
  (reagent/render [main-panel] (.getElementById js/document "app")))
