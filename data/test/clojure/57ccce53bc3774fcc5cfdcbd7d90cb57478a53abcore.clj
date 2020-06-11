(ns dreams_bucket.core
  (:require [ring.adapter.jetty :as jetty]
            [dreams_bucket.db_connect :as db]
            [clojure.java.jdbc :as jdbc]
            [compojure.core :refer [defroutes GET POST]]
            [compojure.route :refer [resources]]
            [net.cgrand.enlive-html :as enlive]))


;; Get all bucket activities
(defn get_bucket_activities []
(jdbc/with-connection db/postgresql-db
  (jdbc/with-query-results results
    ["SELECT * FROM tbl_bucket_activity"]
    (into [] results))))

;; Define the templates
(enlive/deftemplate all_wishes_page "templates/all_wishes.html"
  []
  [:head :title] (enlive/content "Dreams Bucket | Home")
  [:div#side-menu :h1] (enlive/content "Dreams Bucket")
  [:b#bucket_title] (enlive/clone-for [s (map :bucket_activity_name (get_bucket_activities))](enlive/content s))
  [:div#bucket_name :button] (enlive/clone-for [s (map :bucket_name (get_bucket_activities))](enlive/content s))
  [:div#bucket_description :p] (enlive/clone-for [s (map :bucket_activity_description (get_bucket_activities))](enlive/content s)))

(enlive/deftemplate my_wishes_page "templates/my_wishes.html"
  []
  [:head :title] (enlive/content "Dreams Bucket | My Wishes")
  [:body :div#side-menu :h1] (enlive/content "Dreams Bucket")
  [:b#bucket_title] (enlive/clone-for [s (map :bucket_activity_name (get_bucket_activities))](enlive/content s))
  [:div#bucket_name :button] (enlive/clone-for [s (map :bucket_name (get_bucket_activities))](enlive/content s))
  [:div#bucket_description :p] (enlive/clone-for [s (map :bucket_activity_description (get_bucket_activities))](enlive/content s)))

(enlive/deftemplate manage_account_page "templates/manage_account.html"
  []
  [:head :title] (enlive/content "Dreams Bucket | Profile")
  [:body :div#side-menu :h1] (enlive/content "Dreams Bucket"))

(enlive/deftemplate private_wishes_page "templates/private_wishes.html"
  []
  [:head :title] (enlive/content "Dreams Bucket | Private Wishes")
  [:body :div#side-menu :h1] (enlive/content "Dreams Bucket")
  [:b#bucket_title] (enlive/clone-for [s (map :bucket_activity_name (get_bucket_activities))](enlive/content s))
  [:div#bucket_name :button] (enlive/clone-for [s (map :bucket_name (get_bucket_activities))](enlive/content s))
  [:div#bucket_description :p] (enlive/clone-for [s (map :bucket_activity_description (get_bucket_activities))](enlive/content s)))

(enlive/deftemplate public_wishes_page "templates/public_wishes.html"
  []
  [:head :title] (enlive/content "Dreams Bucket | Public Wishes")
  [:body :div#side-menu :h1] (enlive/content "Dreams Bucket")
  [:b#bucket_title] (enlive/clone-for [s (map :bucket_activity_name (get_bucket_activities))](enlive/content s))
  [:div#bucket_name :button] (enlive/clone-for [s (map :bucket_name (get_bucket_activities))](enlive/content s))
  [:div#bucket_description :p] (enlive/clone-for [s (map :bucket_activity_description (get_bucket_activities))](enlive/content s)))

(enlive/deftemplate wish_form_page "templates/wish_form.html"
  []
  [:head :title] (enlive/content "Dreams Bucket | Wish Form")
  [:body :div#side-menu :h1] (enlive/content "Dreams Bucket"))

(defroutes dreams_bucket
"Implement routing"
  (GET "/" [] (all_wishes_page))
  (GET "/my_wishes" [] (my_wishes_page))
  (GET "/manage_account" [] (manage_account_page))
  (GET "/private_wishes" [] (private_wishes_page))
  (GET "/public_wishes" [] (public_wishes_page))
  (GET "/wish_form" [] (wish_form_page))
  (resources "/css" {:root "static/css"})
  (resources "/js" {:root "static/js"})
  (resources "/img" {:root "static/img"})
  (resources "/fonts" {:root "static/fonts"}))


(defn -main []
  (jetty/run-jetty dreams_bucket {:port 3000}))


