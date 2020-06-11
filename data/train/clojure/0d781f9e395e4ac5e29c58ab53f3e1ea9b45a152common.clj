(ns cloauth.views.common
  (:use noir.core
        hiccup.core
        hiccup.page-helpers
         hiccup.form-helpers)
  (:require [cloauth.models.kdb :as db]
            [noir.session :as session]
            [gitauth.gitkit :as gitkit]
            ))

; Define all of the CSS and JS includes that we might need
(def includes {:jquery (include-js "http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js")
               :jquery-ui (include-js "https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.2/jquery-ui.min.js")
               :jquery-local (include-js "/js/jquery-1.7.1.min.js")
               :jquery-ui-local (include-js "/js/jquery-ui-1.8.16.custom.min.js")
               :bootstrap (include-css "/css/bootstrap.css")
               :bootstrap-responsive (include-css "/css/bootstrap-responsive.css")
               :google-apis (include-js "https://ajax.googleapis.com/ajax/libs/googleapis/0.0.4/googleapis.min.js")
               :jsapi (include-js "https://ajax.googleapis.com/jsapi")
               ; bootstrap javascript
               :bootstrap-js (include-js "/js/bootstrap.js")
               ; bit of script to enable various bootstrap 2.0 javascript stuff
               :bootstrap-js-init (javascript-tag "$(document).ready(function () { 
                               $('.alert-message').alert();  });")
              })

; css and js includes that every page will need
; For now this is the same as the above list!
(def base-includes [:bootstrap :bootstrap-responsive :jquery :jquery-ui 
                    :bootstrap-js :bootstrap-js-init :jsapi :google-apis])

; create the page <head>
(defpartial build-head [static-includes]
            [:head
             [:meta {:charset "utf-8"}]
             [:title "Cloauth"]
             (map #(get includes %) static-includes)
             (gitkit/generate-git-javascript)
              [:style {:type "text/css"}  "body { padding-top: 60px;}  
.sidebar-nav { padding: 9px 0;}"]        
             ])
; "Menu" data structure :title  :check (optional fn to call to see if the menu should be rendered) :links 
(def client-menu {:title "Client Management"
                  :links [["/client/register" "Register Client"]
                          ["/client/admin" "Manage Clients"]]})

(def apps-menu  {:title "My Authorized Applications" 
                 :links [["/oauth2/user/grants" "Authorized Applications" ]]})

(def admin-menu {:title "Admin"  
                 :check-fn db/user-is-admin?
                 :links 
                 [["/admin/user" "Admin/Main"]
                 ]})   

(def test-menu {:title "OAuth Test Pages"
                :links  [["/test" "Test Page"]]})

; todo set default class for link items?
(defpartial link-item [{:keys [url cls text]}]
            [:li (link-to url text)])

(defn menu-items [links]
  (for [[url text] links] 
    [:li (link-to url text )]))

; If a menu has a check function defined call it.
; If the fn returns true we render the menu, else nil 
; This is used to include/exclude menus based on some criteria (role, for example)
(defpartial render-menu [{:keys [title check-fn links]}]
  (if (or (nil? check-fn) 
          (check-fn))
    [:div
     [:li.nav-header title]
     (menu-items links)]))
                          
; Navigation Side bar
(defpartial nav-content []
  [:div.well.sidebar-nav
   [:ul.nav.nav-list
    (render-menu admin-menu)
    (render-menu test-menu)
    (render-menu client-menu)
    (render-menu apps-menu)]])


; Top mast header
; The GIT toolkit will render a sign in button in the chooser div 
; See gitkit.clj
(defpartial topmast-content []
       [:div.navbar.navbar-fixed-top 
         [:div.navbar-inner
          [:div.container-fluid
           [:a.brand {:href "/"} "CloAuth"]
           [:p.pull-right.navbar-text [:div#chooser "Account Chooser"] ]
           ]]])


; Layout with an include map for optional css / js
(defpartial layout-with-includes [ {:keys [css js]} & content]
  ;(prn "option map " css js "content " content)
  (html5 {:lang "en"}
        (build-head base-includes)
            [:body
             (topmast-content)
              [:div.container-fluid 
               [:div.row-fluid
                [:div.span3 (nav-content)]    
                [:div.span9  
                 (if-let [message (session/flash-get :message)]
                    [:div.alert.alert-success.fade.in
                     [:a.close {:data-dismiss "alert" :href "#"} "x" ]
                     message])
                 content]]
                ; [:div.hero-unit  ]]] ; end row-fluid
               [:hr]
               [:footer  [:p "Copyright (c) 2011 Warren Strange"]]]]))

; Standard layout - no additional javascript or css
(defpartial layout [& content]
  ;(prn "Layout " content)
  (layout-with-includes {}, content))
                              

(defn- mktext [keyval text] 
  [:div.clearfix
    (label keyval keyval) 
   [:div.input  
   (text-field {:class "large" :size "40" } keyval text)]])
 
; 
(defpartial simple-post-form [url form-map]
  (form-to [:post url] 
           [:fieldset
           
             (map #(mktext (key %) (val %)) form-map)
           [:div.actions
            [:button.btn.primary "Submit"]
            [:button.btn {:type "reset"} "Reset"]]]))
