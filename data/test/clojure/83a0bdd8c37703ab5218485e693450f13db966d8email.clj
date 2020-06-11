
(ns ^{:author "Ikenna Nwaiwu"} memjore.views.email
    (:require [memjore.views.common :as common])
    (:use [noir.core :only [defpage]]
          [hiccup.form :only [form-to text-area submit-button]]
          [postal.core :only [send-message]]))




(defpage emailcontroller [:post "/manage/emailcontroller"] {:keys [emailmessage]}
  (let [message  emailmessage]
    (send-message message))
  (common/layout
   [:p emailmessage]))


(defpage email "/manage/sendemail" []
  (common/layout
   [:h2 "Send Email" ]

   (form-to [:post "/manage/emailcontroller"]
            (text-area "emailmessage")
            [:p]
            (submit-button "Submit"))
   [:script "CKEDITOR.replace('emailmessage');"]
   ))
