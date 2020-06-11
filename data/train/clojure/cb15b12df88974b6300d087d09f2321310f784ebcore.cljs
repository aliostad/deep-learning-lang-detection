(ns bartleby.core
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [reagent.core :as reagent]
            [re-frame.core :as re-frame]
            [bartleby.events]
            [bartleby.subs :as subs]
            [bartleby.view :refer [ui]]))

(defn mount-root []
  (re-frame/clear-subscription-cache!)
  (reagent/render ui
                  (.getElementById js/document "app")))

(defn ^:export init[]
  (re-frame/dispatch-sync [:initialize-db])
  (re-frame/dispatch [:load-tasks])
  (mount-root))

(defn ^:export load-tasks[]
  (re-frame/dispatch [:load-tasks]))
