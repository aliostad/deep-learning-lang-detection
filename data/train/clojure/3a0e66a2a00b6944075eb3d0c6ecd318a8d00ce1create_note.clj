(ns note.dispatch.create-note
  (:require (note (database :as db_)
                  (html :as html_))
            (note.dispatch (common :as common_))))

(defn- make-body
  [parent-id]
  [:div
   [:form {:method "POST"}
    (html_/hidden "parent-id" parent-id)
    [:fieldset
     (html_/input "Name" :name)
     (html_/textfield "More text" :text)
     (html_/button "Take note")]]])

(defn get-dispatch
  [request]
  (let [parent-id (-> request :params :parent-id)]
    {:body (make-body parent-id)}))

(defn post-dispatch
  [request]
  (let [{:keys [parent-id name text]} (:params request)
        result (db_/add-note parent-id name text)]
    (common_/redirect :task-list)))
