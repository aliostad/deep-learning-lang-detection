(ns ^{:author "Ikenna Nwaiwu"} memjore.views.addmember
  (:require [memjore.views.common :as common])
  (:use [noir.core :only [defpage defpartial render url-for pre-route]]
        [memjore.models.db :as db]
        [noir.response :only [redirect]]
        [hiccup.form :only [form-to]]))

(defpage addmember [:get "/manage/members/add"] {:keys [error] :as req}
  (common/layout
   [:h2 "Add Member"]
   (form-to [:post "/manage/members/add"]
   (common/user-fields req))))

(defpage addmember-handler [:post "/manage/members/add"] {:as req}
  (let [result (db/add-member req)]
    (if (successful-update? result)
      (redirect "/manage/members")
      (addmember (merge result req)))))