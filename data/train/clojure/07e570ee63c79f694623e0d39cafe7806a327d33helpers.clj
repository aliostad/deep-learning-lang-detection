(ns till-clj.views.helpers
  (:require [clojure.string :as str]
            [hiccup.page :as hic-p]
            [till-clj.db :as db]
            [till-clj.totals :as t]))


;;; Universal Helpers

(def header-links
  [:div#header-links
    "[ "
    [:a {:href "/"} "Home"]
    " | "
    [:a {:href "/till/new"} "Configure a new till"]
    " | "
    [:a {:href "/order/new"} "Start a new order"]
    " | "
    [:a {:href "/till/get"} "Manage your till"]
    " ]"])

(defn gen-page-head
  [title]
  [:head
   [:title (str "Till: " title)]
   (hic-p/include-css "/css/styles.css")])

(defn title-banner
  [page-head]
  (hic-p/html5
    (gen-page-head page-head) header-links))


;;; Till/Menu helpers

(def menu-item-line
 [:li [:input {:type "text" :name "menu_item_name" :placeholder "name"}]
  [:input {:type "text" :name "menu_item_price" :placeholder "price"}]])

(defn gen-form-rows
  [form input-num-rows]
  (let [num-rows (t/str->num input-num-rows)]
    (if (<= num-rows 0)
     form
     (gen-form-rows
       (conj form menu-item-line)
       (- num-rows 1)))))

(defn menu-item-rows
  [num-rows]
  (gen-form-rows
    [:ul]
    num-rows))

(defn gen-menu-rows
  [menu-rows till-data & [extra-html]]
  (let [current-row (first till-data)]
    (if (seq till-data)
     (gen-menu-rows (conj menu-rows
                          [:tr
                           [:td (str (current-row :name))
                            [:input {:type "hidden" :name "menu_item_id" :value (str (:id_2 current-row))}]
                            [:input {:type "hidden" :name "menu_item_price" :value (:price current-row)}]]
                           [:td (str (:price current-row))]
                           (if extra-html
                             extra-html)])
                    (rest till-data)
                    extra-html)
      menu-rows)))

;;; Order helpers

(defn gen-order-rows
  [order-rows order-data & [extra-html]]
  (let [current-row (first order-data)]
    (if (seq order-data)
      (gen-order-rows (conj order-rows [:tr
                                        [:td (str (current-row :name))]
                                        [:td (str (current-row :quantity))]
                                        (if extra-html
                                          (extra-html current-row))])
                      (rest order-data)
                      extra-html)
      order-rows)))
