(ns pharmacy.routes
    (:require-macros [secretary.core :refer [defroute]])
    (:import goog.History)
    (:require [secretary.core :as secretary]
              [goog.events :as events]
              [goog.history.EventType :as EventType]
              [re-frame.core :as re-frame]))

(defn handle-url-change [e]
  ;; log the event object to console for inspection
  (js/console.log e)
  ;; and let's see the token
  (js/console.log (str "Navigating: " (.-token e)))
  ;; we are checking if this event is due to user action,
  ;; such as click a link, a back button, etc.
  ;; as opposed to programmatically setting the URL with the API
  ;;(if (.-isNavigation e)
  (if false
    (println "was navigation")
    (do
      ;; in this case, we're setting it
      (println "Token set programmatically")
      ;; let's scroll to the top to simulate a navigation
      (js/window.scrollTo 0 0)))
  ;; dispatch on the token
  (secretary/dispatch! (.-token e)))

(defn hook-browser-navigation! []
  (doto (History.)
    (events/listen
     EventType/NAVIGATE
     ;; (fn [event] (secretary/dispatch! (.-token event)))
     handle-url-change)
    (.setEnabled true)))

(defn app-routes []
  (secretary/set-config! :prefix "#")
  ;; --------------------
  ;; define routes here
  (defroute home "/" []
    (re-frame/dispatch [:set-active-panel :home-panel]))

  ;; --------------------
  ;; Google
  ;; --------------------
  (defroute google "/google" []
    (re-frame/dispatch [:set-active-panel :google-panel]))

  (defroute google-results "/google-results" []
    (re-frame/dispatch [:set-active-panel :google-results-panel]))

  ;; --------------------
  ;; Core Routes
  ;; --------------------

  (defroute consult "/consultation" []
    (re-frame/dispatch [:set-active-panel :consult-panel]))
  
  (defroute dashboard "/dashboard" []
    (re-frame/dispatch [:set-active-panel :dashboard-panel]))

  (defroute drug-detail "/drug/:id" [id query-params]
    (re-frame/dispatch [:view-drug (keyword id)]))

  (defroute menu "/menu" []
    (re-frame/dispatch [:set-active-panel :menu-panel]))

  (defroute join "/join" []
    (re-frame/dispatch [:set-active-panel :join-panel]))

  (defroute treatment-alternatives "/treatment-alternatives" []
    (re-frame/dispatch [:set-active-panel :treatment-alternatives-panel]))
  
  ;; --------------------
  ;; Emails
  ;; --------------------

  (defroute adaptation-email "/adaptation-email" []
    (re-frame/dispatch [:set-active-panel :adaptation-email-panel]))

  (defroute follow-up-email "/follow-up-email" []
    (re-frame/dispatch [:set-active-panel :follow-up-email-panel]))

  (defroute final-cta "/final-cta" []
    (re-frame/dispatch [:set-active-panel :final-cta-panel]))
  
  ;; --------------------
  (hook-browser-navigation!))
