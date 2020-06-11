(ns bmihw.core
    (:require [reagent.core :as reagent :refer [atom]]
              [reagent.session :as session]
              [secretary.core :as secretary :include-macros true]
              [goog.events :as events]
              [goog.history.EventType :as EventType]
              [ajax.core :refer [GET POST]]
              [cljsjs.firebase :as firebase]
              [bmihw.common :refer [auth fb]]
              [bmihw.drunk :as drunk]
              [bmihw.manage :as manage]
              [bmihw.submit :as submit])
    (:import goog.History))

;; -------------------------
;; HOME - LOGIN PAGE
;; -------------------------
(defn auth-handler
  [error, authData]
  (if error
    (reset! auth error)
    (do
      (reset! auth (js->clj authData))
      (session/put! :current-page #'drunk/drunk-page))))

(defn auth-twitter
  []
  (.authWithOAuthPopup fb "twitter" auth-handler))

(defn auth-github
  []
  (.authWithOAuthPopup fb "github" auth-handler))

(defn home-page
  []
  [:div.jumbotron
   [:h1 "Welcome"]
   [:p "Are you ready to intelligently express what a bunch of dumbasses the rest of the world is?  Well, are you?"]
   (if @auth
     (session/put! :current-page #'submit/submit-page)
     [:div
      [:button.btn.btn-primary.btn-lg {:on-click auth-twitter}
       "Login with Twitter"]
      " "
      [:button.btn.btn-primary.btn-lg {:on-click auth-github}
       "Login with Github"]])])

(defn current-page []
  [:div [(session/get :current-page)]])

;; -------------------------
;; Routes
(secretary/set-config! :prefix "#")

(secretary/defroute "/" []
  (session/put! :current-page #'home-page))

(secretary/defroute "/submit" []
  (session/put! :current-page #'submit/submit-page))

;; -------------------------
;; History
;; must be called after routes have been defined
(defn hook-browser-navigation! []
  (doto (History.)
    (events/listen
     EventType/NAVIGATE
     (fn [event]
       (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

;; -------------------------
;; Initialize app
(defn mount-root []
  (reagent/render [current-page] (.getElementById js/document "app")))

(defn init! []
  (hook-browser-navigation!)
  (mount-root))
