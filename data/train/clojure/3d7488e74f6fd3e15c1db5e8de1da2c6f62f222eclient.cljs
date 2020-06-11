(ns duct2.client
  (:require [reagent.core :as reagent]
            [re-frame.core :refer [dispatch dispatch-sync]]
            [duct2.events]
            [duct2.subs]
            [duct2.views]
            )
  )



(defn ^:export main
  []
  ;; Put an initial value into app-db.
  ;; The event handler for `:initialise-db` can be found in `events.cljs`
  ;; Using the sync version of dispatch means that value is in
  ;; place before we go onto the next step.
  (dispatch-sync [:initialise-db])

  ;; Render the UI into the HTML's <div id="app" /> element
  ;; The view function `todomvc.views/todo-app` is the
  ;; root view for the entire UI.
  (reagent/render [duct2.views/task-app]    ;;
                  (.getElementById js/document "app")))
