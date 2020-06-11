(ns centipair.admin.menu
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [reagent.core :as reagent :refer [atom]]
            [centipair.core.ui :as ui]
            [centipair.store.forms :as store-form]
            [centipair.store.product :as product]
            [centipair.site.forms :as site-form]
            [centipair.site.page :as page]
            [centipair.user.manage :as user]
            [centipair.store.dashboard :as dashboard]
            [centipair.core.components.notifier :as notify]
            [centipair.admin.channels :refer [site-selector-channel
                                              active-page
                                              admin-menu-channel]]
            [secretary.core :as secretary :refer-macros [defroute]]
            [cljs.core.async :refer [put! chan <!]]
            [goog.events :as events]
            [goog.history.EventType :as EventType])
  (:import goog.History))


(defn site-url [site-id url]
  (str "/site/" site-id url))


(def admin-menu (atom 
                 [{:label "Dashboard" :url "/dashboard" :id "dashboard" :active false :icon "dashboard"}
                  {:label "Site" :url "/site" :id "site" :active false :icon "newspaper-o"}
                  {:label "Store" :url "/store" :id "store" :active false :icon "shopping-cart"}
                  {:label "Catalogue" :url "/catalogue" :id "catalogue" :active false :icon "table"
                   :children [{:label "Manage Products" :url "/products/0" :id "products" :active false :icon "cubes"}
                              {:label "Product Type" :url "/product-type" :id "product-type" :active false :icon "sliders"}
                              {:label "Categories" :url "/categories" :id "categories" :active false :icon "list"}]}
                  
                  {:label "Pages" :url "/pages/0" :id "pages" :active false :icon "file-text"}
                  {:label "Users" :url "/users/0" :id "users" :active false :icon "users"}
                  {:label "Sales" :url "/sales" :id "sales" :active false :icon "pie-chart"}
                  {:label "Reviews" :url "/reviews" :id "reviews" :active false :icon "comments"}
                  ]))

(defn single-menu-component [each]
  [:li  {:key (str "admin-menu-list-" (:id each)) :class (if (:active each) "active" "")}
       [:a {:href (str "#" (:site-url each)) :key (str "admin-menu-link-" (:id each))}
        [:i {:class (str "fa fa-fw fa-" (:icon each)) }] " "
        (:label each)]])

(defn parent-menu-component [each]
  [:li {:key (str "admin-menu-list-" (:id each)) :class (if (:active each) "active" "")}
   [:a {:href "javascript:;"
        :data-toggle "collapse"
        :data-target (str "#" (:id each) "-children")
        :key (str "admin-menu-link-" (:id each))}
    [:i {:class (str "fa fa-fw fa-" (:icon each))}] " "
    (:label each)
    [:i {:class "fa fa-fw fa-caret-down"}]]
   [:ul {:id (str (:id each) "-children")
         :class "collapse"
         :key (str (:id each) "-children")}
    (map single-menu-component (:children each))]])


(defn menu-item [each]
  (if (:children each)
    (parent-menu-component each)
    (single-menu-component each)))

(defn menu-component [com-data]
  [:ul {:class "nav navbar-nav side-nav" ;;old class: nav nav-sidebar 
        :key (str "admin-menu-container" )}
   (map menu-item @com-data)])

(defn admin-menu-component []
  (menu-component admin-menu))


(defn render-admin-menu []
  (reagent/render [admin-menu-component]
                            (. js/document (getElementById "admin-menu"))))


(defn update-child-menu-items [site-id menu-item]
  (assoc menu-item :site-url (site-url site-id (:url menu-item))))

(defn update-menu-item [site-id menu-item]
  (let [updated-menu-item (assoc menu-item :site-url (site-url site-id (:url menu-item)))]
    (if (:children updated-menu-item)
      (assoc updated-menu-item
             :children 
             (map (partial update-menu-item site-id) (:children updated-menu-item)))
      updated-menu-item)))


(defn update-site-admin-menu [site-id]
  (do
    (reset! admin-menu (into [] (map (partial update-menu-item site-id) @admin-menu)))
    (render-admin-menu)))

(defn title-component [id]
  (reagent/render
   [:h3 (:label (first (filter (fn [each] (= (:id each) id)) @admin-menu)))]
   (. js/document (getElementById "admin-title"))))


(defn deactivate [id item]
  (if (:children item)
        (assoc item :children (map (partial deactivate id) (:children item)))
        (if (= id (:id item))
          (do
            ;;setting active-page here
            (reset! active-page item)
            (assoc item :active true))
          (assoc item :active false))))


(defn activate-side-menu-item [id & [site-id]]
  ;;(.log js/console site-id)
  (do (notify/notify 200)
      (reset! admin-menu (into [] (map (partial deactivate id) @admin-menu)))
      
      (if (not (nil? site-id))
        (do 
          (put! admin-menu-channel site-id)
          (put! site-selector-channel (js/parseInt site-id))))))


(defn activate-independent-item [item & [site-id]]
  (let [id (:id item)]
    (activate-side-menu-item id site-id)
    (reset! active-page item)))


(defroute dashboard "/site/:site-id/dashboard" {site-id :site-id}
  (activate-side-menu-item "dashboard" site-id)
  (dashboard/render-dashboard site-id))


(defroute settings "/site/:site-id/store" {site-id :site-id}
  (activate-side-menu-item "store" site-id)
  (store-form/render-store-form site-id))

(defroute site "/site/:site-id/site" {site-id :site-id}
  (activate-side-menu-item "site" site-id)
  (site-form/render-site-settings-tabs site-id))

(defroute site-create "/site/:site-id/site/create" {site-id :site-id}
  (activate-side-menu-item "site" site-id)
  (site-form/render-new-site-form))


(defroute manage-products "/site/:site-id/products/:page-number" {page-number :page-number site-id :site-id}
  (activate-side-menu-item "products" site-id)
  (product/activate-product-list page-number))


(defroute create-product "/site/:site-id/product/create" {site-id :site-id}
  (activate-independent-item {:id "product-create" :url "/product/create"} site-id)
  (product/activate-create-product))


(defroute pages "/site/:site-id/pages/:page-number" {page-number :page-number site-id :site-id}
  (activate-side-menu-item "pages" site-id)
  (page/activate-page-list page-number))


(defroute page-create "/site/:site-id/page/create" {site-id :site-id}
  (activate-side-menu-item "pages" site-id)
  (page/new-page))


(defroute page-edit "/site/:site-id/page/edit/:page-id" {site-id :site-id page-id :page-id}
  (activate-side-menu-item "pages" site-id)
  (page/edit-page page-id))


(defroute users "/site/:site-id/users/:page-number" {page-number :page-number site-id :site-id}
  (activate-side-menu-item "users" site-id)
  (user/activate-user-list page-number))


(defroute user-create "/site/:site-id/user/create" {site-id :site-id}
  (activate-side-menu-item "users" site-id)
  (user/render-user-create-form))

(defroute user-edit "/site/:site-id/user/edit/:user-id" {user-id :user-id site-id :site-id}
  (activate-side-menu-item "users" site-id)
  (user/render-user-edit-form user-id))


(defroute sales "/site/:site-id/sales" {site-id :site-id}
  (activate-side-menu-item "sales"))


(defroute reviews "/reviews" []
  (activate-side-menu-item "reviews"))


(defroute search "/search/:url" [url query-params]
  (js/console.log (str "User: " url))
  (js/console.log (pr-str query-params)))


(defroute product-type "/site/:site-id/product-type" {site-id :site-id}
  (activate-side-menu-item "catalogue" site-id)
  (product/render-product-type))


(defroute product-type-create "/site/:site-id/product-type/create" []
  (activate-side-menu-item "product-type")
  (product/render-new-product-type-form))
  

;; Quick and dirty history configuration.
(let [h (History.)]
  (goog.events/listen h EventType/NAVIGATE #(secretary/dispatch! (.-token %)))
  (doto h (.setEnabled true)))

 
(defn init-admin-menu-channel []
  (go (while true
         (update-site-admin-menu (<! admin-menu-channel)))))
