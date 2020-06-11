(ns eat.layout.admin.base
  (:require [eat.layout.user.base :refer [head-tag body-js]]
            [hiccup.element :refer [unordered-list image link-to]]
            [hiccup.core :refer [html]]
            [hiccup.form :as f]))

(defn- create-content-link []
  [:div {:class "dropdown"}
       [:button {:class "btn btn-primary dropdown-toggle"
                 :type "button" :id "new-content-menu"
                 :data-toggle "dropdown" :aria-expanded "false"}
        "Create Content"]
       (unordered-list {:class "dropdown-menu" :role "menu" :aria-labelledby "new-content-menu"}
                       [(link-to "/admin/new-post" "New Post")])])

(defn admin-nav [user]
  [:header {:class "navbar navbar-default navbar-fixed-top" :role "banner"}
   [:div {:class "container"}
    [:div {:class "navbar-header"}
     [:button {:type "button" :class "navbar-toggle collapsed" :data-toggle "collapse" :data-target "#navbar" :aria-expanded "false" :aria-controls "navbar"}
      [:span {:class "sr-only"} "Toggle navigation"]
      [:span {:class "icon-bar"}]
      [:span {:class "icon-bar"}]
      [:span {:class "icon-bar"}]]
     (link-to {:class "navbar-brand"} "/"
              (image {:height "25"} "https://mdbootstrap.com/img/logo/mdb-transparent.png"))]
    
    [:div {:id "navbar" :class "collapse navbar-collapse" :role "navigation"}
     (unordered-list {:class "nav navbar-nav navbar-right"}
                     [(if user (link-to {:class "text-uppercase"} "admin/main" (str "Welcome, " user)))
                      (f/form-to ["POST" "/logout"]
                                 (f/submit-button {:class "btn btn-primary"} "Logout"))])]]])

(defn admin-header [create-content?]
  [:header {:id "header"}
   [:div {:class "container"}
    [:div {:class "row"}
     [:div {:class "col-md-9"}
      [:h1 " " 
       [:span {:class "glyphicon glyphicon-cog"}]" Dashboard " 
       [:small "Manage Your Site"]]]
     (if create-content?
       [:div {:class "col-md-3 create"} (create-content-link)])]]])

(defn admin-breadcrum []
    [:section {:id "breadcrumb"}
     [:div {:class "container"}
      [:ol {:class "breadcrumb"}
       [:li {:class "active"} "Dashboard"]]]])

(defn admin-base [layout-config {:keys [title pre-content content posts user create-content?]}]
  (html
   [:html
    (head-tag title)
    [:body
     (admin-nav user)
     (admin-header create-content?)
     (admin-breadcrum)
     pre-content
     [:div {:class "content-wrapper"}
      [:div {:class "container"}
       content]]
     (body-js)]]))

