(ns szama.views
  (:use [hiccup.core]
        [hiccup.page]
        [hiccup.form]
        [hiccup.element]
        [korma.core]
        [szama.db]))

; helpers
(defn delete-form [url]
  (form-to [:delete url]
    (submit-button "Delete")))

(defn number-to-currency [amount]
  (format "%.2f" (/ amount 100.0)))

(defn format-date [date]
  (let [fm (new java.text.SimpleDateFormat "yyyy-mm-dd hh:mm:ss")]
    (.format fm date)))

(format-date (new java.util.Date))

; templates
(defn layout [content]
  (html
    (html5
      [:html
        [:head
          [:title "Szama"]]
        [:body content]]
      )))

(defn user-select [name]
  [:select {:name name}
    [:option {:value ""} ""]
    (map (fn [u] [:option {:value (u :id)} (u :name)]) (select users))])

(defn order-form-table [n key header]
  [:div
    [:h3 header]
    [:table
      [:tr
        [:th "User"]
        [:th "Amount"]]
      (map (fn [i]
        [:tr
          [:td (user-select (str key "[" i "][user_id]"))]
          [:td (text-field (str key "[" i "][amount]"))]])
        (take n (range)))]])

(defn order-form []
  (form-to [:post "/orders"]
    (order-form-table 10 "eaters" "Eaters")
    [:div
      (label "delivery" "Delivery")
      (text-field "delivery")]
    (order-form-table 3 "payers" "Payers")
    [:div
      (submit-button "Create order")]))

(defn home [orders users]
  [:div
    [:h2 "Recent orders"]
    [:table
      [:tr
        [:th "Date"]
        [:th "Amount"]
 ;       [:th "Caller"]
       ]
      (map (fn [o]
        [:tr
          [:td (format-date (o :created_at))]
          [:td (number-to-currency (o :total))]
;          [:td (o :caller)]
         ])
        orders)]
    [:h2 "Users"]
    [:a {:href "/users"} "Manage"]
    [:table
      [:tr
       [:th "Name"]
       [:th "Balance"]]
      (map (fn [u]
       [:tr
         [:td (u :name)]
         [:td (number-to-currency (u :balance))]])
       users)]

    (order-form)])

(defn users-index [users]
  [:div
    [:a {:href "/"} "Back"]
    [:div
      [:table
        [:tr
          [:th "Name"]
          [:th "Delete"]]
        (map (fn [a]
          [:tr
            [:td (a :name)]
            [:td (delete-form (str "/users/" (a :id)))]])
          users)]]
    [:div
      (form-to [:post "/users"]
        [:div
          (label "name" "Name")
          (text-field "name")]
        [:div
          (submit-button "Create user")])]])
