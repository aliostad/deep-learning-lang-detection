(ns CPG.views.data
  (:require [CPG.views.common :as common])
  (:require [CPG.models.data :as model])
  (:require [clojure.string])
  (:use [noir.core :only [defpage defpartial]]))

(defn input-id [item]
  (str "datavalue_" (model/key item)))

(defn update-js [item]
  (common/js-call :window.document.cpg.updateData 
                  (model/key item)
                  (input-id item)))

(defn delete-js [item]
  (common/js-call :window.document.cpg.deleteData
                  (model/key item)))

(defpartial data-row [item]
  [:tr
    [:td [:strong (model/key item)]]
    [:td [:input.span7 {:id (input-id item) 
                              :value (model/value item)}]]
    [:td (common/onclick-link :a.btn.btn-mini.btn-success 
                              (update-js item) "update") 
         "&nbsp;"
         (common/onclick-link :a.btn.btn-mini.btn-danger 
                              (delete-js item) "delete")]])

(defpartial data-table []
  [:table.table.table-condenced.table-striped 
   [:thead [:th.span3 "KEY"]
           [:th.span7 "VALUE"]
           [:th.span2 "&nbsp;"]]
   [:tbody (->> (model/get-all)
                (sort-by :_id)
                (map data-row))]])

(defpage "/manage-data" []
  (common/layout
    [:div.row
     [:div.span12
      [:h1 "Manage data"]
      [:p "These values can be merged into the profile text. 
          Review them before each profile generation to ensure they are up-to-date."]
      [:p.pull-right
       (common/onclick-link :a.btn.btn-primary 
                            (common/js-call :window.document.cpg.addNewDataField) 
                            "Add a new data field..")]
      (data-table)]]))

(defpage [:post "/save-data"] {:as item}
  (model/save (:key item) (:value item))
  "save ok")

(defpage [:post "/delete-data"] {:as item}
  (println "DELETE" item)
  (model/delete (:key item))
  "delete ok")
