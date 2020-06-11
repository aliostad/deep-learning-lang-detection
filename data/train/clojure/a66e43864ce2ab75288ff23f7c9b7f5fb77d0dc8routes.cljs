(ns merkledag.browser.routes
  (:require-macros
    [secretary.core :refer [defroute]])
  (:require
    [clojure.string :as str]
    [goog.events :as events]
    [goog.history.EventType :as EventType]
    [multihash.core :as multihash]
    [re-frame.core :refer [dispatch]]
    [secretary.core :as secretary])
  (:import
    goog.History))


(secretary/set-config! :prefix "#")


(def history
  "Hook into browser navigation events."
  (doto (History.)
    (events/listen
      EventType/NAVIGATE
      (fn [event]
        (secretary/dispatch! (.-token event))))
    (.setEnabled true)))


(defroute home-path "/" []
  (dispatch [:show-view :home]))


(defroute blocks-path "/blocks/" []
  (dispatch [:show-view :blocks-list]))


(defroute block-path "/block/:id" [id]
  (dispatch [:show-view :block-info {:id id}]))


; TODO: support path traversal
(defroute node-path "/nodes/:id" [id]
  ; TODO: handle errors here
  (let [id (multihash/decode id)]
    (dispatch [:show-view :node-detail {:id id}])))


(defroute refs-path "/refs/" []
  (dispatch [:show-view :refs-list]))


(defroute ref-path "/refs/:name" [name]
  (dispatch [:show-view :ref-detail {:name name}]))


(defroute #"/data/([^/]+)(/.*)?" [root path]
  (dispatch [:show-view :data-path {:root root, :path (str/split path #"/")}]))

(defn data-path
  ([root]
   (data-path root nil))
  ([root path]
   (str "#/data/" root (when (seq path) (str "/" (str/join "/" path))))))


; TODO: handle unmatched routes (404)
