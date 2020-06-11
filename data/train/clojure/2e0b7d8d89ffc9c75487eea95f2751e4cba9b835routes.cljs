(ns playground-coffeeshop.routes
  (:require-macros [secretary.core :refer [defroute]])
  (:require
    [secretary.core :as secretary]
    [reagent.core :as reagent :refer [atom]]
    [re-frame.core :as re-frame]
    [goog.events :as events]
    [goog.history.EventType :as EventType]
    [accountant.core :as accountant])
  (:import goog.history.Html5History
           goog.Uri))

(accountant/configure-navigation!
  {:nav-handler  (fn [path]
                   (secretary/dispatch! path))
   :path-exists? (fn [path]
                   (secretary/locate-route path))})

(defn hook-browser-navigation! []
  (let [history (doto (Html5History.)
                  (events/listen
                    EventType/NAVIGATE
                    (fn [event]
                      (secretary/dispatch! (.-token event))))
                  (.setUseFragment false)
                  (.setPathPrefix "")
                  (.setEnabled true))]
    (events/listen js/document "click"
                   (fn [e]
                     (let [path (.getPath (.parse Uri (.-href (.-target e))))
                           title (.-title (.-target e))]
                       (when (secretary/locate-route path)
                         (. history (setToken path title))))))))

(defn app-routes []
  ;; --------------------
  ;; define routes here
  (defroute "/" []
            (re-frame/dispatch [:set-active-view :home-view]))
  (defroute "/blog" []
            (re-frame/dispatch [:set-active-view :blog-view]))
  (defroute "/about" []
            (re-frame/dispatch [:set-active-view :about-view]))
  (defroute "/menus" []
            (re-frame/dispatch [:set-active-view :menus-view]))
  (defroute "/events" []
            (re-frame/dispatch [:set-active-view :events-view]))
  (defroute "/bookings" []
            (re-frame/dispatch [:set-active-view :bookings-view]))
  (defroute "/consignment" []
            (re-frame/dispatch [:set-active-view :consignment-view]))
  (defroute "/contact" []
            (re-frame/dispatch [:set-active-view :contact-view]))
  (defroute "/:id" {:as params}
            (re-frame/dispatch [:set-active-view :event-view (:id params)]))


  ;; --------------------
  (hook-browser-navigation!))
