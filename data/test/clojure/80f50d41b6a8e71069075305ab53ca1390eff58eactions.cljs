(ns ui.main.actions
  (:require [re-frame.core :refer [dispatch dispatch-sync]]
            [ui.util.events :as util]
            [ui.core.routes :as routes]
            [clojure.string :as str]
            [cljs-uuid-utils.core :as uuid]))

(defn handle-message-input-key-stroke
  [channel]
  (fn
    [e]
    (let [message (:current-message channel)]
      (when (and
             (not (nil? message))
             (not (str/blank? message))
             (not (.-shiftKey e))
             (= (.-key e) "Enter"))
        (do
          (.preventDefault e)
          (dispatch [:send-current-message {:client-id (str (uuid/make-random-uuid))
                                            :user "me"
                                            :channel (:id channel)
                                            :body message}]))))))

(defn update-current-message
  [e]
  (.preventDefault e)
  (dispatch-sync [:update-current-message (util/event->value e)]))
