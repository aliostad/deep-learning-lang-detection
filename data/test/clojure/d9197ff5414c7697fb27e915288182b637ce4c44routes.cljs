(ns lipstick.routes
  (:import goog.History)
  (:require-macros [secretary.core :refer [defroute]]
                   [taoensso.timbre :as log])
  (:require [goog.events :as events]
            [goog.history.EventType :as EventType]
            [re-frame.core :as rf]
            [clojure.string :refer [blank? starts-with?]]
            [clojure.test :refer [function?]]
            [bidi.bidi :as bidi]
            [clojure.string :as str]
            [lipstick.tools.utils :as u]))

(defn handle-token [path]
  (let [pairs (for [pair (str/split path #"&")]
                (let [[k v] (str/split pair #"=")]
                  [(keyword k) v]))
        query (into {} pairs)
        auth (assoc query :expires-after
                          (u/after-now (:expires-in query)))]
    (rf/dispatch [:set-auth auth])))


(def routes ["#/" {""      :home-page
                   "about" :about-page}])


(defn dispatch-path
  "Dispatches active handler from routes mapping.
  Dispatch can be rf/dispatch or rf/dispatch-sync."
  [dispatch-fn path]
  (let [handler (->> path
                     (bidi/match-route routes)
                     (:handler))]
    (dispatch-fn [:set-active-page handler])))


(defn navigate-hook [event]
  (let [path (-> event .-token)]
    (cond
      (str/includes? path "access_token=") (handle-token path)
      (blank? path) (dispatch-path rf/dispatch "#/")
      :else         (dispatch-path rf/dispatch path))))


(defn navigate-sync [window]
  (let [raw-path (-> window .-location .-hash)
        path     (if (blank? raw-path) "#/" raw-path)]
    (dispatch-path rf/dispatch-sync path)))


(defn init-routes []
  (navigate-sync js/window)
  (log/debug "Hooking into browser navigation")
  (doto (History.)
    (events/listen EventType/NAVIGATE navigate-hook)
    (.setEnabled true)))


(def url-for (partial bidi/path-for routes))