(ns mgrapi.views.myaccount.login
  (:require
    [mgrapi.views.myaccount.common :refer [decorate style page-width page-width-numeric section-table manage-print-products online-products other-links with-validation]]

    [hiccup.element :refer [link-to]]
    [hiccup.form :refer [form-to label text-field password-field submit-button]]
  )
  (:use
    [ring.util.response :as response :only [response]]
    [clojure.tools.logging :as log]
  )
)

(defn- login-page []
  (list
    [:tr { :valign "top" }
      [:td
        [:table { :class "section-table" }
          [:tr
             [:th "Manage online products" ]
          ]
          [:tr
            [:td 
              [:b "If you are already a subscriber to any of the online products or services listed below, enter your username and password to access your account information." ]
              [:table (style :color "#474747")
                [:tr
                  [:td { :width "50%", :style "padding: 0px; font-size: 11px; font-weight: bold;" } "- ConsumerReports.org" ]
                  [:td { :rowspan 2, :valign "top", :style "padding: 0; font-size: 11px; font-weight: bold;" } "- ConsumerReports.org Cars Best Deals Plus" ]
                ]
                [:tr
                  [:td { :style "padding: 0px; font-size: 11px; font-weight: bold;" } "- " [:em "CR"] " Car Pricing Service" ]
                ]
              ]
              (form-to [:post ""]
                [:table { :id "login-table" }
                  [:tr
                    [:td (label  "userName" "Username:") ]
                    [:td (with-validation text-field "userName") ]
                    [:td { :rowspan 2, :valign "bottom" } (submit-button "Log In")]
                  ]
                  [:tr
                    [:td (label "password" "Password:") ]
                    [:td (password-field "password") ]
                  ]
                  [:tr
                    [:td { :colspan 3 }
                      [:span { :class "font-size10" }
                        (link-to "/ec/myaccount/forgot_username.htm" "Forgot your username?")
                        [:br]
                        (link-to "/ec/myaccount/forgot_password.htm" "Forgot your password?")
                        [:br]
                        (link-to "http://custhelp.consumerreports.org/cgi-bin/consumerreports.cfg/php/enduser/std_adp.php?p_faqid=34" "Need help loggin in?")
                      ]
                    ]
                  ]
                ]
              )
            ]
          ]
          [:tr
            [:td
              [:strong
	              [:span (style :color "#CC0000") "Not a subscriber? "]
	              "Learn more about our online products and services."
	            ]
              [:p]
              (online-products)
            ]
          ]
        ]
      ]
      [:td { :width "40%" }
        (section-table "Manage print products" manage-print-products)
        (section-table "Other links" other-links)
      ]
    ]
  )
)

(defn login [request]
  (decorate "Welcome to CRO Login Page" login-page 2)
)

(defn- home-page []
  (list
    [:tr { :valign "top" }
      [:td
        (section-table "My online products" #(list [:center [:b "You have no subscriptions available." ]]))
        (section-table "My personal information" #(list))
        (section-table "My online gift subscriptions" #(list))
        (section-table "Other online products" online-products)
      ]
      [:td { :width "40%" }
        (section-table "Manage print products" manage-print-products)
        (section-table "Other links" other-links)
      ]
    ]
  )
)

(defn home [request]
  (set! field-map (:session request))
  (decorate "Welcome to CRO Home Page" home-page 2)
)

(defn do-login [request]
  (let
    [
      user-name (:userName (:params request))
      password (:password (:params request))
    ]
    (log/info "do-login: user-name =" user-name ", password =" password)
    (response/redirect "/ec/myaccount/main.htm")
  )
)

