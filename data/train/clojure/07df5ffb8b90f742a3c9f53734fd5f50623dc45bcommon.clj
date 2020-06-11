(ns mgrapi.views.myaccount.common
  (:use
    [clojure.tools.logging :as log]
  )
  (:require
    [hiccup.element :refer [image link-to unordered-list]]
    [hiccup.page :refer [html5 include-css]]
    [hiccup.util :refer [url]]
  )
)

; http://stackoverflow.com/questions/12679754/idiomatic-way-of-rendering-style-info-using-clojure-hiccup
(defn style [& info]
  {
    :style (.trim (apply str (map #(let [[kwd val] %] (str (name kwd) ": " val "; ")) (apply hash-map info))))
  }
)

(def page-width-numeric 770)

(def page-width (str page-width-numeric "px"))

(declare ^:dynamic field-map)

(defn decorate [title bodyfn colspan]
;  (log/info "request=" request)
  (html5
    [:head
      [:title title]
      (include-css "/css/myaccount/screen.css")
    ]
    [:body
      [:table (style :margin-left "15px" :margin-top "0" :width page-width)
        [:tr
          [:td { :colspan colspan }
            [:table { :align "right" }
              [:tr
                [:td (link-to "http://custhelp.consumerreports.org/cgi-bin/consumerreports.cfg/php/enduser/home.php" (image "/img/myaccount/head_custservice.gif" "Customer Service")) ]
                [:td (link-to "/ec/myaccount/main.htm" (image "/img/myaccount/head_account.gif" "My Account")) ]
                [:td (link-to "http://www.consumerreports.org/cro/our-web-sites/index.htm" (image "/img/myaccount/head_products_cro.gif")) ]
              ]
            ]
          ]
        ]
        [:tr
          [:td { :colspan colspan }
	          [:table (style :cursor "pointer" :border "1px solid #B3BBC9" :background "url(/img/myaccount/back_dot_cro.gif)" :margin-top "20px" :width page-width)
	            [:tr
	              [:td (style :padding "0") (link-to "http://www.consumerreports.org" (image "/img/myaccount/head_crtitle.gif")) ]
	            ]
	          ]
          ]
        ]
        [:tr
          [:td { :colspan colspan }
	          [:table { :width page-width }
	            [:tr
	              [:td (link-to "http://www.consumerreports.org" (image { :width (dec page-width-numeric)} "/img/myaccount/account_head.jpg")) ]
	            ]
	          ]
          ]
        ]
        (bodyfn)
        [:tr
          [:td { :colspan colspan, :class "font-size10" }
            "Copyright &copy; 2006-2013 " 
            (link-to "http://www.consumerreports.org" "Consumer Reports")
            ". No reproduction, in whole or in part, without written "
            (link-to "http://www.consumerreports.org/cro/about-us/no-commerical-use-policy/permission-requests/index.htm" "permission")
            "."
          ]
        ]
      ]
    ]
  )
)

(def magazine-section
  (
    [title code subscribe_url gift_url]
    (list
	    [:b (str "Consumer Reports " title)] [:br]
      [:span { :class "font-size11" }
    	  (link-to (url "https://w1.buysub.com/servlet/CSGateway" { :cds_mag_code code }) "Access Account")
	      " | "
	      (link-to subscribe_url "Subscribe")
        " | "
	      (link-to gift_url "Give a gift")
      ]
    )
  )
  (
    [title code product subscribe_intkey gift_intkey]
    (magazine-section
      title
      code
      (url "/ec/" product "/order.htm" (if (nil? subscribe_intkey) {} { :INTKEY subscribe_intkey }))
      (url "/ec/" product "/gift/order.htm" (if (nil? gift_intkey) {} { :INTKEY gift_intkey }))
    )
  )
)

(defn section-table [header bodyfn]
  (list
    [:table { :class "section-table" :width "95%" }
      [:tr
        [:th header ]
      ]
      [:tr
        [:td
          (bodyfn)
        ]
      ]
    ]
  )
)

; def evaluates only on the first call, defn [] evaluates on every call
(def other-links
  (unordered-list
    (list
      (link-to "http://custhelp.consumerreports.org/cgi-bin/consumerreports.cfg/php/enduser/home.php" "Customer service")
      (link-to "http://custhelp.consumerreports.org/cgi-bin/consumerreports.cfg/php/enduser/home.php" "Frequently asked questions")
      (link-to "http://www.consumerreports.org/cro/customer-service/privacy.htm" "Privacy")
      (link-to "http://www.consumerreports.org/cro/customer-service/security.htm" "Security")
      (link-to "http://www.consumerreports.org/cro/customer-service/reprints/reprints-and-permissions.htm" "Reprints and permissions")
      (link-to "http://www.consumerreports.org/cro/customer-service/email-service/e-mail-newsletters/index.htm?email=" "Manage your FREE newsletter")
    )
  )
)

(def manage-print-products
  (list
    (magazine-section "Magazine" "CNS" "cr" nil "IG106C")
    [:p]
    (magazine-section "on Health" "CRH" "oh" "IW03CHMA" "IG106H")
    [:p]
    (magazine-section "Money Adviser" "CRM" "ma" nil "IG106M")
    [:p]
    (magazine-section "ShopSmart" "SHM"
      (url "https://w1.buysub.com/servlet/OrdersGateway" { :cds_mag_code "SHM", :cds_page_id 42071, :cds_response_key "" })
      (url "https://w1.buysub.com/pubs/C8/SHM/lp45.jsp" { :cds_mag_code "SHM", :cds_page_id 43404 })
    )
  )
)

(def online-products
  (list
    [:strong "ConsumerReports.org" ] [:br]
    [:span { :class "font-size10" }
      (link-to "/cro/features-tools/index.htm" "Learn More")
      " | "
      (link-to "/ec/cro/order.htm?INTKEY=I925LT0" "Subscribe")
      " | "
      (link-to "/ec/cro/gift/order.htm?INTKEY=GY3700A" "Give a gift subscription")
    ]
    [:p]
    [:strong "ConsumerReports.org Cars Best Deals Plus" ] [:br]
    [:span { :class "font-size10" }
      (link-to "/ec/carp/order.htm?INTKEY=I990C" "Subscribe")
    ]
    [:p]
    [:strong "ConsumerReports.org Cars Pricing Service" ] [:br]
    [:span { :class "font-size10" }
      (link-to "/ec/aps/order.htm?INTKEY=WA37M00" "Subscribe")
    ]
  )
)

; Supported element functions: text-field
(defn with-validation [elem-name elem-fn validation-fn]
  (log/info "elem-name =" elem-name)
  (log/info "elem-fn =" elem-fn)
  (log/info "validation-fn =" validation-fn)
  (let
    [
    ]
  )
  (assoc fild-map elem-name validation-fn)
  (elem-fn elem-name)
)
