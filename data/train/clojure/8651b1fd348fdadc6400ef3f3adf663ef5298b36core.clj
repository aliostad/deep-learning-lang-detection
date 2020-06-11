(ns frereth-renderer.session.core
  (:require [frereth-renderer.geometry :as geometry]
            [ribol.core :refer (manage on raise)]
            [schema.core :as s]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Schema

(def Session {:title s/Str
              :position geometry/Rectangle
              :id s/Uuid})

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Helpers

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Public

(comment (s/defn init :- Session
           "This is pretty horribly over-simplified.
But it's a start
"
           [{:keys [left top width height title update-function]
             :or {left 0
                  top 0
                  width 1024
                  height 768
                  title "Frereth"}}]
           (map->Session {:position {:left left
                                     :top top
                                     :width width
                                     :height height}
                          :title title})))
