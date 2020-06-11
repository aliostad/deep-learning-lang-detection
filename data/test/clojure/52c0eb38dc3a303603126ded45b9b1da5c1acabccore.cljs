(ns aco.client.core
  (:require [reagent.core :as reagent :refer [atom]]
            [re-frame.core :as re-frame :refer [dispatch-sync dispatch]]
            [aco.index.handlers :as index-handlers]
            [aco.index.subs :as index-subs]
            [aco.single.handlers :as single-handlers]
            [aco.single.subs :as single-subs]
            [aco.tags.handlers :as tags-handlers]
            [aco.tags.subs :as tags-subs]
            [aco.client.handlers :as handlers]
            [aco.client.subs :as subs]
            [aco.client.views :refer [current-page]]))

(defn mount-root []
  (reagent/render [current-page] (.getElementById js/document "app")))

(defn init! []
  (dispatch-sync [:init])
  (dispatch [:index/request-acos])
  (mount-root))
