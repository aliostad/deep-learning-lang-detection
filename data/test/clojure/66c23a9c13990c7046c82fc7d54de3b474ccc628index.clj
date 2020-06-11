(ns ku-expo.index
  (:require [ring.util.response :refer [response]]
            [hiccup.page :as page]))

(defn- render-body
  []
    [:html
     [:head
    [:meta {:charset "utf-8"}]
     [:title "KU Expo"]
     (page/include-css "/css/bootstrap.min.css")
     (page/include-css "/css/bootstrap-theme.min.css")
     (page/include-js "/js/jquery-1.11.2.min.js")
     (page/include-js "/js/bootstrap.min.js")]
   [:body
    [:div.navbar.navbar-default
     [:div.container
      [:div.navbar-header
       [:a.navbar-brand {:href "/"} "KU Expo"]]
      [:div#navbar.navbar-collapse.collapse
       [:ul.nav.navbar-nav
        [:li
         [:a {:href "/teacher"} "Teacher"]]
        [:li
         [:a {:href "/group"} "Student Group"]]]
       [:ul.nav.navbar-nav.navbar-right
        [:li
         [:button.btn.btn-default.navbar-btn {:type "button"}
          [:a {:href "/logout"} "Sign Off"]]]]]]]
    [:div.container
     [:div.jumbotron
      [:div.row
       [:h2 "Welcome to Expo!"]
       [:p "This service provides registration for all faculty attending the KU Engineering Expo."]
       [:p "You may create a new account to register your school, students, teams, and logistics information by following the link below"]]
      [:div.row
       [:div.col-xs-2.col-xs-offset-5
        [:a.btn.btn-primary.btn-block {:href "/register"} "Register"]]]
      [:hr]
      [:div.row
       [:p "You may also log back in and manage your attendance information through the login page"]]
      [:div.row
       [:div.col-xs-2.col-xs-offset-5
        [:a.btn.btn-primary.btn-block {:href "/login"} "Login"]]]]]]])

(defn index
  []
  (response (page/html5 (render-body))))

