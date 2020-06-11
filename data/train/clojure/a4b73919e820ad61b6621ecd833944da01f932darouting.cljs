(ns phonsole-client.routing
  (:require [secretary.core :as secretary :refer-macros [defroute]]
            [pushy.core :as pushy]
            [phonsole-client.auth :refer [parse-id-token]]
            [re-frame.core :refer [dispatch]]
            [phonsole-client.pages.home :refer [home-page]]
            [phonsole-client.pages.help :refer [help-page]])
  (:import goog.history.Html5History))

(defroute "/" []
  (dispatch [:set-page home-page]))
(defroute "/help" []
  (dispatch [:set-page help-page]))
(defroute "*" []
  (dispatch [:set-page (fn []
                         [:p "Page Not found"])]))

(secretary/set-config! :prefix "/")

(def history (pushy/pushy secretary/dispatch!
                          (fn [x]
                            (when (secretary/locate-route x) x))))

(defn start! []
  (pushy/start! history))

(defn stop! []
  (pushy/stop! history))
