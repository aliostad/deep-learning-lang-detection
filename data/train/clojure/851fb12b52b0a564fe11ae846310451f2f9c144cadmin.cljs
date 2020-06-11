(ns misabogados-workflow.admin
  (:require [reagent.core :as r]
            [reagent.session :as session]
            [misabogados-workflow.admin.users :refer [users-tab]]
            [misabogados-workflow.admin.categories :refer [categories-tab]]
            [misabogados-workflow.admin.lawyers :refer [lawyers-tab]]
            [misabogados-workflow.admin.settings :refer [settings-tab]]
            [secretary.core :as secretary :include-macros true]))

;; (defn settings-tab []
;;   (fn [] [:p "Hello1"]))

(def tabs
  {:users #'users-tab
   :categories #'categories-tab
   :lawyers #'lawyers-tab
   :settings #'settings-tab})

(defn tab []
  [(tabs (session/get-in [:admin :tab]))])

(defn admin []
  (fn []
    (when-not (session/get-in [:admin :tab]) (session/assoc-in! [:admin :tab] :users))
    [:div.container-fluid
     [:div.row
      [:div.sidebar.col-sm-3.col-md-2
       [:ul.nav.nav-sidebar
        [:li {:class (if (= (session/get-in [:admin :tab]) :users) "active")}
         [:a {:href "#admin/users"} "Manage users"]]
        [:li {:class (if (= (session/get-in [:admin :tab]) :categories) "active")}
         [:a {:href "#admin/categories"} "Manage categories"]]
        [:li {:class (if (= (session/get-in [:admin :tab]) :lawyers) "active")}
         [:a {:href "#admin/lawyers"} "Manage lawyer profiles"]]
        [:li {:class (if (= (session/get-in [:admin :tab]) :settings) "active")}
         [:a {:href "#admin/settings"} "Manage settings"]]
        ]]
      [:div.col-sm-9.col-sm-offset-3.col-md-10.col-md-offset-2.admin-tab
       [:h1 "Admin Dashboard"]
       [tab]]]
     ]))

(secretary/defroute "/admin/categories" []
  (do (session/put! :page :admin)
      (session/assoc-in! [:admin :tab] :categories)))

(secretary/defroute "/admin/users" []
  (do (session/put! :page :admin)
      (session/assoc-in! [:admin :tab] :users)))

(secretary/defroute "/admin/lawyers" []
  (do (session/put! :page :admin)
      (session/assoc-in! [:admin :tab] :lawyers)))

(secretary/defroute "/admin/settings" []
  (do (session/put! :page :admin)
      (session/assoc-in! [:admin :tab] :settings)))
