(ns hallway.ui.manage-doctors-panel
  (:require [clojure.tools.logging :as log]
            [hallway.model.doctors :as doc]
            [seesaw.table :as tbl]
            [seesaw.bind  :as b])
  (:use [seesaw
         [core :exclude (separator)]
         [util :only [resource]]
         mig]
        [hallway.ui.util :only [trim-values load-data-in-table]]
        hallway.ui.actions))

(defn- keyword-renderer [renderer {:keys [value]}]
  (apply config! renderer [:text (resource (keyword (str value)))]))

(defn- select-doctor-pane [v]
  (select v [:#doctorpane]))

(defn- select-doctor-table [view]
  (select view [:#doctor-table]))

(defn- find-doctor-pane [e]
  (-> e
      to-root
      select-doctor-pane))

(defn- find-doctor-table [e]
  (-> e
      to-root
      select-doctor-table))

(defn- clear-input-fields [e]
  (-> e
      find-doctor-pane
      (value! {:initials ""
               :name     ""})))

(defn- new-action [appstate]
  (action :name "new"
          :handler (fn [e]
                     (clear-input-fields e)
                     (reset! (:current-doctor-id appstate) -1)
                     (-> e
                         find-doctor-table
                         (selection! nil)))))

(defn- save-action [appstate]
  (action :name "Save"
          :handler (fn [e]
                     (-> e
                         find-doctor-pane
                         value
                         trim-values
                         (assoc :id @(:current-doctor-id appstate))
                         doc/save-doctor)
                     (reset! (:doctors appstate) (doc/find-all-doctors))
                     (clear-input-fields e))))


(defn- doctor-table []
  (scrollable (table
               :selection-mode :single
               :id :doctor-table
               :model [:columns [{:key :initials :text ::initials}
                                 {:key :name     :text ::name}
                                 {:key :type     :text ::type}]])))

(defn- edit-doctor-pane [appstate]
  (mig-panel :id :doctorpane
   :constraints ["inset 10" "[right]10[grow,fill]"]
   :items       [[(doctor-table)            "span,grow"]
                 [(label :text ::initials ) ""]
                 [(text  :id    :initials)  "wrap"]
                 [(label :text ::name)      ""]
                 [(text  :id    :name)      "wrap"]
                 [(label :text "specialisatie") ""]
                 [(combobox :id :type
                            :model [:gyneacologist :pediatrician]
                            :renderer keyword-renderer)      "wrap"]
                 [(new-action appstate)              "span,split"]
                 [(save-action appstate)    ""]
                 [(close-action appstate)   ""]]))

(defn- create-view [appstate]
  (border-panel
   :border 5
   :center (edit-doctor-pane appstate)))

(defn init [appstate]
  (let [current-doctor-id (atom -1)
        view (create-view (assoc appstate :current-doctor-id current-doctor-id))
        doctortable (select-doctor-table view)]
    (b/bind (:doctors appstate)
            (b/b-do [doctors]
                    (load-data-in-table  (select-doctor-table view) doctors)))

    (b/bind (b/selection doctortable)
            (b/some identity)
            (b/transform (partial tbl/value-at doctortable))
            (b/tee 
             (b/value (select-doctor-pane view))
             (b/bind
              (b/transform :id)
              current-doctor-id)))
    
    view))
