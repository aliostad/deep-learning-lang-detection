(ns orbit.render
  (:require 
    [ajax.core :refer [GET]]
    [re-frame.core :refer [dispatch dispatch-sync]]
    [reagent.core :as r]
    [orbit.events]
    [orbit.subs]
    [orbit.router :as router]
    [orbit.views :as views]))

(enable-console-print!)

(defn render [orbit dom-target]
  (dispatch-sync [:init! orbit])
  (r/render [views/orbit-view] dom-target)
  (GET (str "orbits/rustyspoon.md")
    {:handler (fn [raw-content]
                (dispatch [:set-content! raw-content]))}))

(defonce once
  (do
    (router/init!)))
