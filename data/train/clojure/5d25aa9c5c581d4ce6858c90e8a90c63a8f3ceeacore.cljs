(ns organizer.core
  (:require [reagent.core :as reagent]
            [re-frame.core :as re-frame]
            [organizer.events]
            [organizer.subs]
            [organizer.views :as views]))

(defn mount-root []
  (re-frame/clear-subscription-cache!)
  (reagent/render [views/page]
                  (.getElementById js/document "organizer")))

(defn ^:export init []
  (re-frame/dispatch-sync [:initialize-db])
  (re-frame/dispatch [:current-page js/window.location.pathname])
  (re-frame/dispatch [:fetch-todos])
  (mount-root))
