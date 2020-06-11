(ns kbo.handler
  (:use [liberator.core :only [defresource]])
  (:require [compojure.core :refer [ANY GET defroutes]]
            [ring.middleware.params :refer [wrap-params]]
            [compojure.route :refer [not-found resources]]
            [hiccup.page :refer [include-js include-css html5]]
            [kbo.middleware :refer [wrap-middleware]]
            [config.core :refer [env]]))

(def mount-target
  [:div#app
      [:h3 "ClojureScript has not been compiled!"]
      [:p "please run "
       [:b "lein figwheel"]
       " in order to start the compiler"]])

(defn head []
  [:head
   [:meta {:charset "utf-8"}]
   [:meta {:name "viewport"
           :content "width=device-width, initial-scale=1"}]
   (include-css (if (env :dev) "/css/site.css" "/css/site.min.css"))])

(def loading-page
  (html5
    (head)
    [:body {:class "body-container"}
     mount-target
     (include-js "/js/app.js")]))


(defresource medlemmer []
  :available-media-types ["application/json"]
  :handle-ok (fn [_] (repeat 10 {:navn "Søren" :instrument "Barytonsax"})))

(defroutes routes
  (GET "/" [] loading-page)
  (GET "/about" [] loading-page)
  (GET "/medlemmer" [] (medlemmer))
                                        ;(GET "/nisse/:t" [t] (nisse t))

  (not-found "Not Found"))

(def app (wrap-middleware #'routes))
