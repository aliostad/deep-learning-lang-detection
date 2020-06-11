(ns hallway.ui.manage-rooms-panel
  (:require [clojure.tools.logging :as log]
            [hallway.model.rooms :as room]
            [seesaw.table :as tbl]
            [seesaw.bind  :as b])
  (:use [seesaw
         [core :exclude (separator)]
         [util :only [resource]]
         mig]
        [hallway.ui.util :only [trim-values load-data-in-table]]
        hallway.ui.actions))

(defn- select-room-table [view]
  (select view [:#roomtable]))

(defn- find-room-pane [e]
  (-> e
      to-root
      (select [:#roompane])))

(defn- find-room-table [e]
  (-> e
      to-root
      select-room-table))

(defn- clear-values [e]
  (-> e
      find-room-pane
      (value! {:roomnumber ""})))

(defn- add-action [appstate]
  (action :name "Add"
          :handler (fn [e]
                     (-> e
                              find-room-pane
                              value
                              trim-values
                              room/save-room)
                     (clear-values e)
                     (load-data-in-table (find-room-table e) (room/all-rooms)))))

(defn- delete-action [appstate]
  (action :name "Delete"
          :handler (fn [e]
                     (let [roomtable (-> e find-room-table)]
                       (->> roomtable
                           selection
                           (tbl/value-at roomtable)
                           room/remove-rooms)
                       (load-data-in-table (find-room-table e) (room/all-rooms))))))


(defn- rooms-table []
  (scrollable (table :id :roomtable
                      :model [:columns [:roomnumber]])))

(defn- edit-rooms-pane [appstate]
  (mig-panel
   :id :roompane
   :constraints ["inset 10","[right]10[grow,fill]"]
   :items       [[(rooms-table)            "span,grow"]
                 ["Nummer"                 ""]
                 [(text :id :roomnumber)        "wrap"]
                 [(add-action appstate)    "span,split"]
                 [(delete-action appstate) ""]
                 [(close-action appstate)  ""]]))


(defn- create-view [appstate]
  (border-panel
   :border 5
   :center (edit-rooms-pane appstate)))

(defn init [appstate]
  (let [view (create-view appstate)]
    (load-data-in-table (select-room-table view) (room/all-rooms))

    view
    ))

