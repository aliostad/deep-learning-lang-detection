(ns magnet.bez2.core
  (:require [reagent.core :as reagent :refer [atom]]
            [re-frame.core :as re-frame :refer [dispatch-sync dispatch]]
            [magnet.bez2.handlers]
            [magnet.bez2.subs]
            [magnet.index.handlers]
            [magnet.index.subs]
            [magnet.book.handlers]
            [magnet.book.subs]
            [magnet.bez2.views :refer [current-page]]))

;; -------------------------
;; Initialize app
(defn mount-root []
  (reagent/render [current-page] (.getElementById js/document "app")))

(defn init! []
  (dispatch-sync [:init])
  (dispatch [:index/request-books])
  (mount-root))
