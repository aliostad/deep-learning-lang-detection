(ns budget.renderer
  (:use [hiccup core page]
        (sandbar stateful-session)
        budget.manage-redis
        budget.constants
       	budget.charts
   		[clj-time local core format]))

(defn render-transaction-list [transactions account]
  [:table.table
   (map 
    #(let [amount (. Integer parseInt (% :amount))
          display-time (unparse (formatters :date) (parse (formatters :date-hour-minute-second) (% :time)))]
      (vector :tr {:class (if (> 0 amount) "success" "")}
        [:td display-time] [:td (% :item)] [:td (. Math abs amount)]))
   transactions)])

(defn page-wrap [main-content]
      (html5
      [:head
       	[:meta {:name "apple-mobile-web-app-capable" :content "yes"}]
        [:title "Budget"]
        (include-css "/css/swipe.css")
        (include-css "/css/bootstrap.css")
        (include-css "/css/budget.css")
        (include-css "/css/bootstrap-responsive.css")
        (include-js "/scripts/flotr2.min.js")
        (include-js "/scripts/swipe.min.js")
        (include-js "/scripts/no_safari.js")
        [:meta {:name "viewport", :content "width=device-width, initial-scale=1.0"}]]
      (concat []
        main-content)))

(defn render-login []
   (page-wrap
       [[:h1 "Log in"]
       [:form {:method "post" :action "/login"}
         [:label "Username"]
         [:input {:type "text", :placeholder "username", :name "username", :id "username"}]
         [:label "Password"]
         [:input {:type "password", :placeholder "password", :name "password", :id "password"}]
         [:div.form-actions [:input {:class "btn btn-primary" :type "submit"}]]]
       [:h1 "Sign up"] 
       [:form {:method "post" :action "/signup"}
         [:label "Username"]
         [:input {:type "text", :placeholder "username", :name "username", :id "username"}]
         [:label "Password"]
         [:input {:type "password", :placeholder "password", :name "password", :id "password"}]
         [:label "Monthly budget"]
         [:div.input-prepend
           [:span.add-on "$"]
           [:input {:type "number" :placeholder "Round up to the nearest dollar", :name "budget", :id "budget"}]]
         [:div.form-actions [:input {:class "btn btn-primary" :type "submit"}]]]
]))

   
(defn render-main [account-name month-string]
  (println "month" month-string)
    (let [month (if month-string (parse dateformat month-string) (first-of-the-month (local-now)))
          is-current-month (= month (first-of-the-month (local-now)))
          [transactions total account-string monthly-budget] (if month-string (account-fetch account-name (unparse dateformat month)) (account-fetch account-name))]
      (page-wrap
        [[:div.container-fluid
          [:div.row-fluid
            [:div.span3
         	  [:div.well
                [:h1.center (if is-current-month (str "$" total) (unparse (formatters :year-month) month))]]
             (if (= 0 (count transactions)) [:p.text-warning "no transactions for this month"]
              [:div#chart-slider 
               [:ul
                [:li 
                   (render-chart "Extra savings" transactions total plot-budget-left
							(fn[x y] (- y (- monthly-budget (* x monthly-budget 0.033333)))))]
                [:li 
                   (render-chart "Spent" transactions total plot-total-spent
							(fn[x y] y))]
                [:li 
                   (render-chart "Money left" transactions total plot-budget-left
                            (fn[x y] y)
                            (fn[x y] (- monthly-budget (* x monthly-budget 0.033333))))]]])
              [:form {:method "post" :action "/update"}
               	[:input {:type "hidden" :value account-name :name "account", :id "account"}]
                [:fieldset
                 [:label "Item"]
				 [:input {:type "text", :placeholder "What are you buying", :name "item", :id "item"}]
                 [:label "Cost"]
                 [:div.input-prepend
                  [:span.add-on "$"]
                  [:input {:type "number" :placeholder "Round up to the nearest dollar", :name "amount", :id "amount"}]]
				 [:div.form-actions
                  [:input {:class "btn btn-primary" :type "submit"}]]]]
              [:a.btn {:href (str "/?month=" (previous-month-string month))} "Prev"]
              [:a (if is-current-month
                      {:class "btn disabled pull-right"}
                      {:class "btn pull-right" :href (str "/?month=" (next-month-string month))})
                  "Next"]
              [:hr]
              (render-transaction-list transactions account-name)
              [:a.btn {:href "/logout"} "Logout"]
              [:script {:type "text/javascript"} 
                "new Swipe(document.getElementById('chart-slider'));"]
               ]]]])))

(defn render-message [message-markup wait-time]
  (html5
    [:head
     [:meta {:HTTP-EQUIV "REFRESH" :content (str wait-time "; url=/")}]
     [:title (str "Confirmed!")]
     (include-css "/css/bootstrap.css")
     (include-css "/css/budget.css")
     (include-css "/css/bootstrap-responsive.css")
     [:meta {:name "viewport", :content "width=device-width, initial-scale=1.0"}]]
   [:body 
    [:div.container-fluid
          [:div.row-fluid
            [:div.span3
         	  [:div.well
                [:h1.center message-markup]]]]]]))
(defn random-affirmation []
  (rand-nth ["OK" "Great!" "Nice" "Good choice" "I like it!" "Sweet" "Awesome" "Rock on" "Thanks" ]))
