(ns com.nth.app.model
  (:require-macros [hiccups.core :as h]
                   [fetch.macros :as fm])
  (:require [fetch.core :as remotes]
            [com.nth.app.api.dispatch :as dispatch]
            [hiccups.runtime :as hiccupsrt]
            [com.nth.app.api :as api]
            [com.nth.app.model.ui :as ui]))


(def containerId (atom {}))
(def state (atom {}))

(add-watch state :state-change-key
           (fn [key a old-val new-val]
             (dispatch/fire :state-change new-val)))

(dispatch/react-to #{:state-change} 
                   (fn [id m]
                     (ui/set-html! (ui/by-id (:container @containerId)) (ui/html-table (:result m )))))


(defn ^:export init [id]
  (swap! containerId assoc :container id)
  (fm/remote (res-list 1 5) [result]
             (swap! state assoc :result result)))

