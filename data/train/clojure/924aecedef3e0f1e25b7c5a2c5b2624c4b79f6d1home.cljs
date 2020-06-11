;; Senior Project 2015
;; Elevent Solutions -- Client
;; Leslie Baker and Oscar Marshall

(ns elevent-client.pages.home
  (:require [elevent-client.routes :as routes]
            [elevent-client.state :as state]))

(defn module
  "Reagent component that defines the large buttons found on the home page."
  [text icon destination]
  [:div.four.wide.column
   [:div.ui.segment {:style {:padding "0"
                             :height "200px"}}
    [:button.ui.blue.basic.fluid.button {:style {:height "100%"}
                                         :on-click #(js/location.assign destination)}
     [:h1.ui.header text]
     [:h1.ui.header [:i.icon.centered
                     {:class icon}]]]]])

(defn page
  "Reagent component that defines the home page."
  []
  [:div.sixteen.wide.column
   (let [logged-in? (:token @state/session)]
     [:div.ui.sixteen.column.grid
      [:div.sixteen.wide.column
       [:div.ui.segment
        [:h1.ui.dividing.header "Welcome to Elevent Solutions"]
        [:h3.ui.header "What would you like to do?"]]]
      [:div.two.wide.column]
      (when-not logged-in?
        [module "Log in" "sign in" (routes/sign-in)])
      (when-not logged-in?
        [module "Sign up" "add user" (routes/sign-up)])
      [module "Browse events" "search" (routes/events-explore)]
      (when logged-in?
        [module "View my events" "ticket" (routes/events)])
      (when logged-in?
        [module "Manage my organizations" "building" (routes/organizations-owned)])
      [:div.two.wide.column]])])

(routes/register-page routes/home-chan #'page)
