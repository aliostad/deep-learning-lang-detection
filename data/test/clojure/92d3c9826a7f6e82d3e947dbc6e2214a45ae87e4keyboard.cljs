(ns seqseq.keyboard
  (:require [re-frame.core :refer [dispatch subscribe]]
            [goog.events :as events])
  (:import [goog.events EventType]))

(defn handle-key-press [k e]
  (when (= "x" k)
    (dispatch [:delete-selected-notes]))
  (when (= " " k)
    (.preventDefault e)
    (.stopPropagation e)
    (dispatch [((deref (subscribe [:transport]))
                {:stop :play
                 :play :stop})]))
  (let [pos (.indexOf "qwerasdf" (str k))]
    (when (> pos -1) (dispatch [:toggle-mute pos])))
  (when (= "u" k)
    (dispatch [:undo]))
  (when (and (= "r") (.-ctrlKey e))
    (dispatch [:redo])))

(defn init []
  (let [keyup (fn [e]
                (handle-key-press (.fromCharCode js/String (.-keyCode e)) e))]
    (events/removeAll js/window EventType.KEYPRESS)
    (events/listen js/window EventType.KEYPRESS keyup)))
