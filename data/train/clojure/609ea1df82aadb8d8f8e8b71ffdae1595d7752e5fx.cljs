(ns vivavocab.games.common.state.fx
  (:require
    [re-frame.core :refer [dispatch]]))

(def timeouts (atom {}))

(defn dispatch-later
  [[event key delay]]
  (js/clearTimeout (@timeouts key))
  (swap! timeouts assoc key
    (js/setTimeout
      (fn [] (dispatch event))
      delay)))

(defn dispatch-later-cancel
  [key]
  (js/clearTimeout (@timeouts keys)))

(defn play [path]
  (.play (js/Audio. (str path))))

(defn play-word [word-id]
  (when word-id
    (play (str "/word-audio/en-ca/" word-id ".mp3"))))
