(ns playground-coffeeshop.components.footer
  (:require [re-frame.core :as re-frame]))

(defn footer-component []
  (fn []
    [:div.footer.flex-row
      [:div.info
        [:b "Playground Coffee Shop"] [:br]
        "1114 Bedford Ave." [:br]
        "Brooklyn, NY 11216" [:br]
        "(718) 484-4833"]
      [:div.flex-row.subscribe-and-social
        [:div.subscribe
          [:b "Mailing List"]
          [:div#mc_embed_signup
           [:form#mc-embedded-subscribe-form.validate
            {:action "//playgroundcoffeeshop.us14.list-manage.com/subscribe/post?u=a23e239d84897ac1d24bcdfc0&amp;id=0ca6986d5f",
             :noValidate "noValidate",
             :target "_blank",
             :name "mc-embedded-subscribe-form",
             :method "post"}
            [:div#mc_embed_signup_scroll
             [:div.mc-field-group
              [:input#mce-EMAIL.required.email
               {:name "EMAIL",
                :value nil,
                :type "email"}]]
             [:div#mce-responses.clear
              [:div#mce-error-response.response]
              [:div#mce-success-response.response]]
             [:div.mc-hidden
              {:aria-hidden "true"}
              [:input
               {:value nil,
                :tabIndex "-1",
                :name "b_a23e239d84897ac1d24bcdfc0_0ca6986d5f",
                :type "text"}]]
             [:div.clear
              [:input#mc-embedded-subscribe.button
               {:name "subscribe",
                :value "> Subscribe",
                :type "submit"}]]]]]]
        [:div.social
          [:div.socialbtns
            [:ul
              [:li
               [:a.fa.fa-sm.fa-facebook
                {:href "https://www.facebook.com/playgroundcoffeeshopbk/"}]]
              [:li
               [:a.fa.fa-sm.fa-instagram
                {:href "https://www.instagram.com/playgroundcoffeeshop/"}]]]]]]]))
