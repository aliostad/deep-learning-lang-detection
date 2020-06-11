(ns re-frame-blog.routes
    (:require-macros [secretary.core :refer [defroute]])
    (:import goog.History)
    (:require [secretary.core :as secretary]
              [goog.events :as events]
              [goog.history.EventType :as EventType]
              [re-frame.core :as re-frame]))

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
    (re-frame/dispatch [:set-active-panel :index-panel]))

  (defroute "/blog/:index" {:as params}
    (def index (js/parseInt (params :index)))
    (re-frame/dispatch [:set-active-panel :blog-panel])
    (re-frame/dispatch [:set-active-post  index]))

  (defroute "/edit/:index" {:as params}
    (def index (js/parseInt (params :index)))
    (re-frame/dispatch [:set-active-panel :edit-panel])
    (re-frame/dispatch [:set-active-post  index]))

  (defroute "/new" []
    (re-frame/dispatch [:set-active-panel :new-panel]))

  ;; --------------------
  (hook-browser-navigation!))
