(ns ^{:author "Ikenna Nwaiwu"} memjore.views.editmember
  (:require [memjore.views.common :as common])
  (:use [noir.core :only [defpage]]
        [memjore.models.db :as db]
        [noir.response :only [redirect]]
        [hiccup.form :only [form-to]]))

(defpage editpage "/manage/members/edit/:id" {:keys [id] :as req}
  (common/layout
   [:h2 "Edit Member"]
   (common/display-error-messages-if-any req) ;; replace with flash
   (form-to [:post "/manage/members/editpagehandler/"]
            (common/user-fields (get-member id)))))

(defpage editpagehandler [:post "/manage/members/editpagehandler/"] {:as req}
   (do
     (let [id (:id req)
           result (db/edit-member id req)]
       (if (successful-update? result)
         (redirect "/manage/members")
         (editpage (merge req result))))))
