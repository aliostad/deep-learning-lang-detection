(ns turnboss.views.layouts
  (:use [hiccup.core :only [html]]
        [hiccup.util :only [to-uri]]
        [hiccup.page :only [doctype include-css include-js]]
        [hiccup.element :only [unordered-list]]
        [turnboss.components.extras :as extras]
        [turnboss.models.players :as players]
        [turnboss.models.npcs :as npcs]))

(defn common [title & body]
  (html
   (doctype :html5)
   [:head
    [:meta {:charset "utf-8"}]
    [:meta {:http-equiv "X-UA-Compatible" :content "IE=edge,chrome=1"}]
    [:meta {:name "viewport" :content "width=device-width, initial-scale=1, maximum-scale=1"}]
    (include-js "http://localhost:58235/socket.io/lighttable/ws.js")
    (include-css
     "/stylesheets/bootstrap/bootstrap-responsive.min.css"
     "/stylesheets/bootstrap/bootstrap.min.css"
     "/stylesheets/turnboss.css")
    [:title title]
    [:body
     [:div {:class "hero-unit"}
      [:h1 title]
      [:p "Crush them. See them driven before you."]]
     [:div {:class "container-fluid"}
      [:div {:class "row-fluid"} body]]]
    (include-js (extras/google-hosted-js-file "jquery" "1.8.3" "jquery.min.js")
                (extras/google-hosted-js-file "jqueryui" "1.10.2" "jquery-ui.min.js")
                "js/bootstrap/bootstrap.min.js"
                "js/main.js")]))
(defn sidebar []
  [:div {:class "span2"}
   [:ul {:class "nav nav-list"}
    [:li {:class "nav-header"} "Lamentation Controls"]
    [:li (extras/add-player-link)]
    [:li (extras/add-npc-link)]
    [:li (extras/manage-roster-link)]]])

(defn roster []
  [:div {:class "row-fluid"}
   [:div {:class "span5"}
    [:div {:class "alert alert-error roster-wrapper"}
     [:h4 {:class "roster-title"} "Roster"]
     (unordered-list {:id "roster"}
                     [[:div {:class "empty-roster-item"} "No Players Added."]])]]])

(defn main-content []
  [:div {:class "span10"}
   [:div {:class "alert alert-info main-blurb"}
    [:button {:type "button" :data-dismiss "alert" :class "close"} "That's why I'm here."]
    [:h4 {:id "main-content"} "Welcome to Turn Master !"]
    [:p {:class "blurb"} (extras/main-content-string)]]
   (roster)])

(defn main-page []
  (common "Turn Master V5.3"
          (sidebar)
          (players/add-player-form)
          (npcs/add-npcs-form)
          (main-content)))

(defn four-oh-four []
  (common "Page Not Found!"
          [:div {:class "span12"}
           [:p "The page you requested could not be found!"]]))
