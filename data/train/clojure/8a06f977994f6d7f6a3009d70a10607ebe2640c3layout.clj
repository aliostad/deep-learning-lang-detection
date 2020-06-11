(ns goldfinchjewellery.views.layout
  (:require [hiccup.element :refer [link-to unordered-list]]
            [hiccup.page :refer [html5 include-css]]
            [noir.session :as session]))

(defn navbar [& items]
  [:nav.navbar.navbar-default {:role "navigation"}
   [:div.conainer-fluid
    [:div.navbar-header
     [:span.navbar-brand "Admin"]]
    [:div.collapse.navbar-collapse
     (unordered-list {:class "nav navbar-nav"}
                     (for [[href text] (remove nil? items)]
                       [:li (link-to href text)]))]]])

(defn common [& content]
  (html5
    [:head
     [:title "Welcome to goldfinchjewellery"]
     (include-css "//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css"
                  "/css/screen.css")]
    [:body
     [:div.container
      (navbar ["/news" "Manage News"]
              ["/jewellery" "Manage Jewellery"]
              (if (session/get :logged-in)
                ["/logout" "Logout"]))
      content]]))
