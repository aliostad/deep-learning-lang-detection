(ns cibo.client.routing
 (:require-macros [secretary.core  :refer [defroute]])
 (:import goog.History)
 (:require [secretary.core         :as secretary]
           [goog.events            :as events]
           [goog.history.EventType :as EventType]
           [re-frame.core          :as re-frame]))

(def history (History.))

(defn navigate! [& uri]
 (.setToken history (apply str uri)))

(defn hook-browser-navigation! []
  (doto history
    (events/listen
     EventType/NAVIGATE
     (fn [event]
       (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

(defn routes []
  (secretary/set-config! :prefix "#")
  (defroute "/" []
   (navigate! "/recipes"))

  (defroute "/recipes" []
   (re-frame/dispatch [:request-recipes])
   (re-frame/dispatch [:select :view :recipes]))

  (defroute "/recipes/:id" [id]
   (re-frame/dispatch [:select :view :show-recipe]))

  (defroute "/menus" []
   (re-frame/dispatch [:request-menus])
   (re-frame/dispatch [:select :view :menus]))

  (defroute "/menus/:id" [id]
   (re-frame/dispatch [:select :view :show-menu]))

  (hook-browser-navigation!))


(js/console.log (-> @re-frame.db/app-db))
