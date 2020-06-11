(ns startingclojure.app
  (:use (compojure handler
                   [core :only (GET POST defroutes)]))
  (:require compojure.route
   [net.cgrand.enlive-html :as html]
   [ring.util.response :as response]
   [ring.adapter.jetty :as jetty]))

; arret 1h20mn
; (defonce server (jetty/run-jetty #'app {:port 8080 :join? false}))

(defonce counter (atom 10000))

(defonce urls (atom {}))

(defn shorten [url]
  (let [id (swap! counter inc)
        id (Long/toString id 36)]
    (swap! urls assoc  id url)
    id)
 )


(html/deftemplate homepage 
  (html/xml-resource "homepage.html")
  [request]
  [:#listing :li] (html/clone-for [[id url] @urls]
                                  [:a]
                                  (comp
                                   (html/content (format "%s : %s" id url))
                                   (html/set-attr :href (str \/ id)))))

(defn redirect [id]
  (response/redirect (@urls id))
  )



(defroutes app* 
  (compojure.route/resources "/")
  (GET "/" request (homepage request))
  (POST "/shorten" request
       (let [id (shorten (-> request :params :url))]
         (response/redirect "/")))
  (GET "/:id" [id] (redirect id))
)


; Middleware to manage request
(def app (compojure.handler/site app*))







