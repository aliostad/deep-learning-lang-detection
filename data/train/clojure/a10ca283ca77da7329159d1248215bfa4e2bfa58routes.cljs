(ns seqseq.routes
  (:require
    [secretary.core :as sec :include-macros true :refer-macros [defroute]]
    [re-frame.core :refer [dispatch]]
    [goog.events :as events]
    [goog.history.EventType :as EventType])
  (:import [goog History]
           [goog.history Html5History]))

(defonce history (new Html5History))

(defn visit [route]
  (.setToken history (apply str (rest route))))

(defroute root "/" []
  (dispatch [:set-current-song nil]))

(defroute songs "/songs" []
  (dispatch [:set-current-song nil]))

(defroute song "/songs/:id" [id]
  (dispatch [:set-current-song (int id)]))

(defroute parts "/songs/:song-id/parts" [song-id]
  (dispatch [:set-current-song (int song-id)]))

(defroute instruments "/songs/:song-id/instruments" [song-id]
  (dispatch [:set-current-song (int song-id)]))

(defroute part "/songs/:song-id/parts/:id" [song-id id]
  (dispatch [:set-current-part (int id)]))

(defn init []
  (events/removeAll history EventType/KEYPRESS)
  (events/listen history
                 EventType/NAVIGATE
                 #(sec/dispatch! (.-token %)))
  (.setUseFragment history false)
  (.setEnabled history true)
  (visit (.. js/window -location -pathname)))
