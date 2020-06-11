(ns moc.ui.common.link
  (:require [re-frame.core :refer [dispatch]]
            [bidi.bidi :as bidi]
            [moc.urls :refer [urls]]
            [moc.router :refer [navigate!]]))

(defn link [opts & children]
  (let [path (:path opts)]
    (into [:a {:href (if path (apply bidi/path-for urls path) "/#")
               :on-click (fn [e]
                           (.preventDefault e)
                           (if path
                             (navigate! path)
                             (dispatch (:dispatch opts))))}]
          children)))
