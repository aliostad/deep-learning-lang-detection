(ns todomvc.core
  (:require-macros [secretary.core :refer [defroute]])
  (:require [goog.events :as events]
            [ampere.core :refer [dispatch dispatch-sync]]
            [secretary.core :as secretary]
            [todomvc.handlers]
            [todomvc.subs :as subs]

            [om.core :as om :include-macros true]
            [ampere.om]
            [todomvc.views.om]

            [reagent.core]
            [ampere.reagent]
            [todomvc.views.reagent])
  (:import goog.History
           goog.history.EventType
           goog.Uri))


(enable-console-print!)

;; -- Routes and History ------------------------------------------------------

(defroute "/" [] (dispatch [:set-showing :all]))
(defroute "/:filter" [filter] (dispatch [:set-showing (keyword filter)]))

(def history
  (doto (History.)
    (events/listen EventType.NAVIGATE
                   (fn [event] (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

;; -- App config

(def config
  {;; i'm lazy to rewrite handlers.cljs, but in real application you probably
   ;; want to have handlers defined separately and registered here
   ;; format is simple: {:handler-id handler-fn or [middleware ... handler-fn]}
   :handlers {}
   :subs {:todos subs/todos
          :showing subs/showing
          :visible-todos subs/visible-todos
          :completed-count subs/completed-count
          :footer-stats subs/footer-stats}})

;; -- Entry Point -------------------------------------------------------------

(defn ^:export main
  []
  (ampere.core/init! config)
  (dispatch-sync [:initialise-db])
  (let [app (.getElementById js/document "app")
        view (.. Uri (parse js/window.location) (getParameterValue "view"))]
    (case view
      "om" (do
             (ampere.om/init!)
             (om/root todomvc.views.om/todo-app nil
                      {:target     app
                       :instrument ampere.om/instrument}))
      "reagent" (do
                  (ampere.reagent/init!)
                  (reagent.core/render [todomvc.views.reagent/todo-app] app))
      nil)))

(main)
