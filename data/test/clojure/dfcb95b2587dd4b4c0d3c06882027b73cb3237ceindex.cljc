(ns vbn.index
  #?(:cljs (:require-macros  [vbn.styler :refer [css at-media]]))
  (:require [rum.core :as rum]
            [vbn.atoms :as atom]
            [vbn.molecules :as molecule]
            [vbn.organisms :as organism]
            #?(:clj [vbn.styler :refer [css at-media get-css-str]])))


     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;;;;;;;;   HOME PAGE SPECIFIC   ;;;;;;;;;;;;
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(rum/defc banner-image[]
  [:div#banner-image.full-width
   [:span "Fostering a better world through business"]])

(rum/defc mail-chimp-form []
  [:div#mc_embed_signup
   [:form#mc-embedded-subscribe-form
    {:action "//veganbusinessnetwork.us13.list-manage.com/subscribe/post?u=3e449a3b219823344ae7ae47a&amp;id=a3633bf54c"
     :method "post"
     :name "mc-embedded-subscribe-form"
     :target "_blank"
     "noValidate" true}
    [:div#mc_embed_signup_scroll
     [:div.mc-field-group
      [:label.sign-up-label {:for "mce-EMAIL"} "Email Address"]
      [:input#mce-EMAIL.required.email {:type "email"}]]

     [:div#mce-responses.clear
      [:div#mce-error-response.response {:style {:display "none"}}]
      [:div#mce-success-response.response {:style {:display "none"}}]]
     [:div {:style {:position "absolute"
                    :left "-5000px"
                    :ariaHidden true}}
      [:input {:type "text"
               :name "b_3e449a3b219823344ae7ae47a_a3633bf54c"
               :tabIndex "-1"
               "value" true}]]
     [:div.clear
      [:input#mc-embedded-subscribe.button {:type "submit"
                                            :value "Subscribe"
                                            :name "subscribe"}]]]]])


(rum/defc sign-up []
  [:div#sign-up {:class ["full-width"
                         "buffer-top-large"
                         (css {:color "white"
                               :background-color "#3a539b"})]}
   [:div  {:class [(css {:width "100vw"
                         :max-width "53em"
                         :align-self "center"
                         :padding-left "1.5em"
                         :padding-right "1.5em"
                         :padding-top "4.5em"
                         :padding-bottom "4.5"
                         :align-items "center"})]}
    [:p "We are always up to new and interesting things. We can send you a few emails from time to time to let you know what is happening in the community."]
    [:div {:class [(css {:width "100%"})
                   (at-media {:min-width "60rem"} {:max-width "35em"})]}
     (mail-chimp-form)]]])










(rum/defc content []
  [:main#main.footer-buffer
   (banner-image)
   (atom/h1-home "Vegan Business Network")
   (organism/bigger-than-business)
   (organism/movement)
   (organism/at-our-core)
   (sign-up)
   (organism/what-we-do)])
   ;[:a {:href "/devcards.html"} "Devcards"]



   ;(hidden)

   ;(link (path-for my-routes :devcards) "Dev Cards")])
