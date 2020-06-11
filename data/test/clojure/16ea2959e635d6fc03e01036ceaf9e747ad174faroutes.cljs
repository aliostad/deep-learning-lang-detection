(ns ui.routes
  (:require [re-frame.core :as re-frame]
            [secretary.core :as secretary :refer-macros [defroute]]
            [accountant.core :as accountant]
            [ui.util :as util]))


(defroute "/" []
  (re-frame/dispatch [:set-active-panel :marketing-panel]))


(defroute "/docs" []
  (re-frame/dispatch [:set-active-panel :doc-panel]))


(defroute "/docs/:item" [item]
  (if (= (keyword item) :sheet)
    (re-frame/dispatch-sync [:init-sheet]))
  (re-frame/dispatch [:set-active-doc-item (keyword item)]))


(defroute "*" []
  (re-frame/dispatch [:set-active-panel :not-found]))


(defn init []
  (secretary/set-config! :prefix "#")
  (re-frame/dispatch-sync [:initialize-db])
  (re-frame/clear-subscription-cache!)
  (accountant/configure-navigation!
   {:nav-handler  secretary/dispatch!
    :path-exists? secretary/locate-route})
  (accountant/dispatch-current!))
