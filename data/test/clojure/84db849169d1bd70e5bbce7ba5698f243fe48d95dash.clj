(ns tinyforum.views.dash
  (:require [noir.response :as resp])
  (:require [noir.session :as sess])
  (:require [tinyforum.views.common :as common])
  (:require [tinyforum.models.static :as static])
  (:use [noir.core :only [render defpage]])
  (:use [tinyforum.util.timing :only [format-time]])
  (:use [hiccup.form :only [form-to
                            label text-area text-field
                            submit-button]])      
  (:use [tinyforum.models.users :only [is-admin? 
                                    user-get
                                    users-get-all 
                                    user-promote! 
                                    user-demote!]]))


(defpage "/manage" []
  (sess/put! :referral "/manage")
       (if (common/logged-in?)
         (common/site-layout
           (if (is-admin? (sess/get :email))
             (list 
               (form-to {:class "manageform"} [:post "/manage/edit"]
                        [:fieldset 
                         [:h4 {:style "color:#666;text-align:center"} 
                          "Edit Site Configuration"]
                         (label "mh" "Masthead")
                         (text-field "mh" (static/get-masthead))
                         (label "ba" "Banner")
                         (text-field "ba" (static/get-banner))
                         (label "le" "Lead")
                         (text-area "le" (static/get-lead))
                         (label "fo" "Footer")
                         (text-field "fo" (static/get-footer))
                         [:br]
                         (submit-button {:style "padding-left:5px;
                                                 font-weight:bold"} "Submit")])
               [:br]
               [:table.table.table-hover
                [:thead {:style "color:#777"} [:tr [:th "users"] [:th "admin"]]]
                (for [u (users-get-all)]
                  [:tr [:th u] 
                     [:th (if (not= u (sess/get :email))
                            (if (is-admin? u) 
                              (form-to {:style "max-width:100px;padding:2px;
                                                margin:0px;margin-top:-5px;"}
                                       [:post (str "/demote/" u)]
                                       "yes, "
                                       (submit-button {:class "userconfirm
                                                              demotebutton"
                                                       :does (str "demote " u "?")} 
                                                      "demote?")) 
                              [:span {:class "formbox"}
                               (form-to {:style "padding:2px;
                                                 margin:0px;margin-top:-3px;"} 
                                        [:post (str "/promote/" u)]
                                        "no, "
                                        (submit-button  {:style "margin-right:8px"
                                                         :class "userconfirm 
                                                                promotebutton"
                                                         :does (str "promote " u "?")} 
                                                       "promote?")
                                        )
                               (form-to {:style "max-width:100px;
                                                 padding:0px;
                                                 margin:0px;"}
                                        [:post (str "/user/" u "/remove")]
                                        (submit-button {:class "doubleconfirm
                                                               deleteuser"
                                                        :does (str "delete user "
                                                                   u "?")} 
                                                       "delete"))]) 
                             (if (is-admin? u) [:span {:style "padding-left:2px"} 
                                                "yes"]
                                               [:span {:style "padding-left:2px"} 
                                                "no"]))]])]
             [:hr] ))
           
           [:table.table.table-hover
            [:thead {:style "color:#777"} [:tr [:th "my topics"] [:th "time"]]]
            (for [topic (:topics (user-get (sess/get :email)))]
              (if topic 
                [:tr 
                 [:th {:style "min-width:268px"} 
                  [:a {:href (str "/topic/" (:id topic))} (:title topic)]] 
                 [:th (format-time (:post-time topic))]]))])
         (resp/redirect "/login")))

(defpage [:post "/manage/edit"] {:keys [mh ba le fo]}
  (if-not (is-admin? (sess/get :email)) (resp/redirect "/"))
  (static/set-masthead! mh) 
  (static/set-banner! ba) 
  (static/set-lead! le) 
  (static/set-footer! fo) 
  (common/flash! (str "Site configuration has been edited."))
  (resp/redirect "/manage"))

(defpage [:post "/promote/:email"] {:keys [email]}
  (if-not (is-admin? (sess/get :email)) (resp/redirect "/"))
  (user-promote! email) 
  (common/flash! (str "User " email " has been promoted to an administrator."))
  (resp/redirect "/manage"))

(defpage [:post "/demote/:email"] {:keys [email]}
  (if-not (or (= email (sess/get :email))
              (is-admin? (sess/get :email)))
    (resp/redirect "/"))
  (user-demote! email)
  (common/flash! (str "User " email " has been demoted to a normal user."))
  (resp/redirect "/manage"))
