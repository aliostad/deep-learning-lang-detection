(ns bio.nebula.client.views.join
  (:require [bio.nebula.client.util :as util]
            [markdown.core :refer [md->html]]))

(defn main []
  (let [mailchimp-endpoint "//nebulabiotech.us2.list-manage.com/subscribe/post?u=28cc4785c874dceaa296ec03b&amp;id=bb5d4b5ccb"]
    [:div {:id "join"}
     [:div (util/unsafe-html :div.notice
                             (md->html
                              "We'll mail you an update when we launch our beta test. If you'd like to support us financially (and we could definitely use the support since we are funding this out-of-pocket right now) feel free to [contact us directly](https://trello.com/c/9roL7q3b/74-contact). We have a payment gateway setup for you to [fund specific projects](https://trello.com/c/WXi42q1U/75-help-fund-us). Thanks, and mahalo!"))]
     [:form {:action mailchimp-endpoint :method "POST" :id "join-email-list-form"}
      [:div.form-row
       [:label {:for "mce-NAME"} [:span "Name"]
        [:input {:id "mcd-NAME" :type "text" :name "NAME"}]]]
      [:div.form-row
       [:label {:for "mce-EMAIL"} [:span "Email"]
        [:input {:id "mce-EMAIL" :type "email" :name "EMAIL"}]]]
      ;; required by MailChimp:
      [:div {:style {:position :absolute :left "-5000px"}}
       [:input {:type "text" :name "b_28cc4785c874dceaa296ec03b_bb5d4b5ccb" :tabindex "-1" :value ""}]]
      [:button {:type "submit"} "Submit"]]]))
