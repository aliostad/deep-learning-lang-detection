(ns till-clj.views.till
  (:require [clojure.string :as str]
            [hiccup.page :as hic-p]
            [till-clj.db :as db]
            [till-clj.views.helpers :as vh]))

(defn get-till-page
  []
  (hic-p/html5
    (vh/title-banner "Enter your till ID")
    [:h1 "Manage your till:"]
    [:p "Please enter your till id:"
     [:form {:action "/till/get" :method "POST"}
      [:input {:type "text" :name "till_id" :placeholder "till-id"}]
      [:input {:type "submit" :value "Submit"}]]]))

(defn new-till-form
  [shop-name address phone path]
  [:form {:action path :method "POST"}
   [:p "Shop Name: " [:input {:type "text" :name "shop-name" :value shop-name :placeholder "your restaurant"}]]
   [:p "Address: " [:input {:type "text" :name "address" :value address :placeholder "restaurant address"}]]
   [:p "Phone: " [:input {:type "text" :name "phone" :value phone :placeholder "0123456789"}]]
   [:p "Number of menu items:" [:input {:type "number" :name "num_menu_items" :placeholder "number of menu items" :value 5}]]
   [:p [:input {:type "submit" :value "Save and continue"}]]])

(defn add-menu-page
  [params]
  (let [[shop-name address phone num-rows]
        (vals params)]
    (hic-p/html5
      (vh/title-banner "Add your menu")
      [:h1 "Configure your menu"]
      [:form {:action "/till/create" :method "POST"}
       [:input {:type "hidden" :name "shop_name" :value shop-name}]
       [:input {:type "hidden" :name "address" :value address}]
       [:input {:type "hidden" :name "phone" :value phone}]
       (vh/menu-item-rows num-rows)
       [:input {:type "submit" :value "Add menu"}]])))

(defn add-till-page
  []
  (hic-p/html5
    (vh/title-banner "Add a till")
    [:h1 "Configure your new till"]
    (new-till-form nil nil nil "/till/menu/new")))

(defn add-till-menu-items
  [params]
  (db/add-till-menu-items! params))

(defn edit-till-page
  [till-id]
  (let [till-data (db/get-till-menu-items till-id)
        first-row (first till-data)
        shop-name (:shop_name first-row)
        address   (:address first-row)
        phone     (:phone first-row)]
    (hic-p/html5
      (vh/title-banner "Edit your till")
      [:h1 "Edit your till"]
      [:form {:action "/till/update" :method "POST"}
       [:input {:type "hidden" :name "till_id" :value till-id}]
       [:p "Shop Name: " [:input {:type "text" :name "shop-name" :value shop-name :placeholder "your restaurant"}]]
       [:p "Address: " [:input {:type "text" :name "address" :value address :placeholder "restaurant address"}]]
       [:p "Phone: " [:input {:type "text" :name "phone" :value phone :placeholder "0123456789"}]]
       [:p [:input {:type "submit" :value "Submit"}]]])))

(defn update-till
  [params]
  (let [[till-id shop-name address phone]
        (vals params)]
    (db/update-till! till-id
                     shop-name
                     address
                     phone)))

(defn menu-page
  [till-id]
  (let [till-data (db/get-till-menu-items till-id)
        first-till (first till-data)]
    (hic-p/html5
      (vh/title-banner (:shop_name first-till))
      [:h1 (first-till :shop_name) ":"]
      [:p "Restaurant id: " (str (:id first-till))]
      [:p "Address: " (:address first-till)]
      [:p "Phone: " (:phone first-till)]
      [:p "Menu: "
       (vh/gen-menu-rows [:table] till-data)]
      [:p [:a {:href (str "/till/edit/" till-id)} "Edit your till"]])))
