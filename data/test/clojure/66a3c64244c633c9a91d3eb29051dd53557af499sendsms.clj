(ns memjore.views.sendsms
  (:require [memjore.views.common :as common])
  (:use [memjore.models.sms :only
         [sms-username-password-set? send-text-to-all-members get-username-password-error-message]]
        [noir.core :only [defpage url-for]]
        [noir.response :only [redirect]]
        [hiccup.form :only [form-to text-area submit-button]]))

(defpage send-text-handler [:post "/manage/sendtexthandler"] {:keys [textmessage]}
  (do
    (if (sms-username-password-set?)
      (do
       (send-text-to-all-members textmessage)
       (common/put-flash-message! "Message sent"))
     (do
       (common/put-flash-message!
        (str "Error sending text. "
             (vals (get-username-password-error-message))))))
    (redirect "/manage/sendtext")))


(defpage "/manage/sendtext" []
  (common/layout
   [:h2 "Send a text" ]
   [:p.error (common/get-flash-message)]
   (form-to [:post (url-for send-text-handler)]
            (text-area "textmessage")
            [:p]
            (submit-button "Submit"))))

