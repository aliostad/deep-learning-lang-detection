(ns ^{:doc "TODO: ns documentation"
      
      :author "Mikkel Christiansen"}

  track.views.tables
  
  (:use [hiccup.def]
        [hiccup.form]
        [track.model :only [fetch-datapoints]]))

(def delete-icon
  "/icons/delete.svg")

(defelem delete [post]
  (form-to [:post post]
           (submit-button {:class "btn"} "Delete")))

(defhtml devices [devices]
  [:table.table.table-striped
   [:thead
    [:tr
     [:th "Device ID"]
     [:th "Location"]]]
   [:body
    (for [d devices]
      [:tr
       [:td (:device_id d)]
       [:td (:location d)]
       [:td (delete (str "/manage/device/" (:device_id d) "/delete"))]])]])

(defhtml series [series]
  [:table.table.table-striped
   [:thead
    [:tr
     [:th "Device ID"]
     [:th "Attribute"]
     [:th "Unit"]]]
   [:body
    (for [s series]
      [:tr
       [:td (:device s)]
       [:td [:a {:href (str "/manage/series/" (:series_id s))} (:attribute s)]]
       [:td (:unit s)]
       [:td (delete (str "/manage/series/" (:series_id s) "/delete"))]])]])

(defhtml datapoints [series]
  (let [datapoints (fetch-datapoints series nil nil nil)]
    [:h1 (:attribute series)]
    [:table.table.table-striped
     [:thead
      [:tr
       [:th "Time"]
       [:th "Measurement"]
       [:th "Unit"]]]
     [:body
      (for [d datapoints]
        [:tr
         [:td (:time d)]
         [:td (:measurement d)]
         [:td (:unit series)]])]]))
