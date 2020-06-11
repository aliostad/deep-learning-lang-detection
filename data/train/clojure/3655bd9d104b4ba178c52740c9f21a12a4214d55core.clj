(ns idManager.core
  (:require [noir.server :as server])
  (:require [noir.response :as response])
  (:require [noir.validation :as vali])
  (:require [monger core])
  (:use [noir.core :only [defpage defpartial render url-for]])
  (:use [hiccup.page :only [html5 include-css include-js]])
  (:use [hiccup.element])
  (:use [hiccup.form])
  (:require [hiccup.util :as hiccup])
  (:require [idManager.domain :as domain]))


(defn -main [& m]
  (let [mode (or (first m) :dev)
        port (Integer/parseInt (get (System/getenv) "PORT" "8080"))
        mongo-uri {:host "localhost" :port 27017 :db "idManager" :auth nil}]
    (monger.core/connect! mongo-uri)
    (monger.core/set-db! (monger.core/get-db (:db mongo-uri)))
    (server/start port {:mode (keyword mode)
                        :ns 'noir}))
 )

(defpartial head-page [] 
  [:head
     [:style
      (hiccup/escape-html "body{padding-top:60px}")]
     [:title "Manage your webapps-id"]
     (include-css "/css/bootstrap.css")])

    
(defpartial layout [ & content ]
  (html5
    (head-page)
    [:body
      [:div.navbar.navbar-fixed-top 
       [:div.navbar-inner
        [:div.container
         (link-to {:class "brand"} "/" "Webapp-id Store")
         [:div.nav-collapse
          [:ul.nav
           [:li.active (link-to "/" "Home")]
           [:li (link-to "/about" "About")]
           [:li (link-to "/contact" "Contact")] ] ] ] ] ]
      content]))


(defpartial display-id [{:keys [_id url userid password]}]
  [:tr
   [:td (link-to {:target "_newwindow"} (str "http://" url) url)]
   [:td userid]
   [:td password]
   [:td (link-to (url-for edit {:id _id}) "Edit")]
   [:td (link-to (url-for delete {:id _id}) "Delete")]
  ]
)
  


(defpartial common-content [ msg ]
    [:br][:br]
    [:div.row
       [:div.span1 
        [:h3 "&nbsp" ]
       ]
       [:div.span7
        [:div.hero-unit 
         [:p msg ]
        ]
       ]
       [:div.span5
        [:h3 "&nbsp"]
       ]
      ]
)

(defpartial error-text [[first-error]]
  [:p.alert-error first-error]
)


(defpartial left-side-content [{:keys [_id url userid password]} post-url form-title] 
  (form-to {:class "form-horizontal"} [:post post-url]
                 [:fieldset
                  [:legend form-title ]
                  (when _id
                    (hidden-field  "_id" _id )) 
                  [:div.control-group
                  (label {:for "url"} "urllbl" "Website URL")
                  (text-field {:class "input-xlarge" :size 55 :maxlength 55} "url" url)
                  (vali/on-error :url error-text)
                  ]
                  [:div.control-group
                  (label {:for "userid"}  "uidlbl" "User Id")
                  (text-field {:class "input-xlarge" :size 25 :maxlength 20} "userid" userid)
                  (vali/on-error :userid error-text)
                  ]
                  [:div.control-group
                  (label {:for "password"}  "pwdlbl" "Password ")
                  (text-field {:class "input-xlarge" :size 15 :maxlength 15 } "password" password)
                  (vali/on-error :password error-text)
                  ]
                  [:div.form-actions
                  (submit-button {:class "btn btn-primary"} " Save ")
                  ]
                 ])
)



(defpartial right-side-content [] 
  [:h3 "List of Webapp Ids"]
        [:table.table.table-bordered.table-striped
         [:th "Webapp/Site "] [:th "User Id"] [:th "Password "]
         (map display-id (domain/get-all))
        ]
)


      
(defpage "/" {:as entry} 
  (layout 
      [:div.row
       [:div.span1 
        [:h3 "&nbsp" ] 
       ]
       [:div.span7
        (left-side-content entry "/save" "Add Webapp-id")
       ]
       [:div.span5
        (right-side-content)
       ]
      ]))
 

   (defpage edit  "/edit/:id"  {id :id}
   (layout
      [:div.row
       [:div.span1 
        [:h3 "&nbsp" ] 
       ]
       [:div.span7
        (left-side-content (domain/find-by-id id)  "/save" "Edit Webapp-id")
       ]
       [:div.span5
        (right-side-content)
       ]
      ]
      ))
 
     
(defn valid? [{:keys [url userid password]}]
  (vali/rule (vali/has-value? password)
             [:password "Please enter password"])
  (vali/rule (vali/min-length? password 8)
             [:password "Password length is too short"])
  (vali/rule (vali/has-value? url)
             [:url "Please enter Webapp Url"])
  (vali/rule (vali/has-value? userid)
             [:userid "Please enter Userid"])
   (not (vali/errors? :url :password :userid))) 
    
    
(defpage [:post "/save"] {:keys [_id url userid password] :as entry}
  (if (valid? entry)
  (do 
    (if _id 
      (domain/update-id _id url userid password)
      (domain/add-new-id url userid password))
    (response/redirect "/" ) )
    (render "/" entry)))
    
(defpage delete "/delete/:id" {:keys [id]}
    (domain/delete-id id)
    (response/redirect "/"))
  

(defpage "/about" []
  (layout
    (common-content "This webapp helps to store your user id and passwords of the websites you are using")))


(defpage "/contact" []
  (layout 
    (common-content "E-mail : abe_v  at  indiatimes.com")))

  
(defn check [] 
  (print "Working "))
