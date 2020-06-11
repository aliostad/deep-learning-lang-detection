(ns hello-compojure.handler
  (:use compojure.core)
  (:require [compojure.handler :as handler]
            [compojure.route :as route]))

;; takes a bunch of forms that map HTTP verbs, uri matches, and
;; destructure params out of the request and can pass to the function
;; this example doesn't really describe what is possible.
(defroutes app-routes
  (GET "/" [] "Hello World")
  (route/resources "/")
  (route/not-found "Not Found"))

(def app-lame
  (handler/site app-routes))

;; suppose we want to dispatch based on page name such as....
;; /index
;; /help
;; /about

(def page-data {:index {:body "I am the index"}
                :help {:body "i am the help page"}
                :about {:body "i am the about page"}})

(defroutes page-dispatch
  (GET "/:page" [page] ((keyword page) page-data)))

(def app-dispatch
  (handler/site page-dispatch))

;; or maybe dispatch to ring handlers
(def page-handlers {:index (fn [request] 
                             {:body (str "I am the index" "\n" (:uri request) (:params request))})
                    :help (fn [request] 
                            {:body (str "i am the help page" "\n" (:uri request) (:params request))})
                    :about (fn [request] 
                             {:body (str "i am the about page" "\n" (:uri request) (:params request))})})


;; note that compjure when presented with a function will pass the
;; request automagically, which is kind of weird, wonder how I would
;; get the params matched from the route passed in? Answer (:params request) hmmmm
(defroutes page-handler-dispatch
  (GET "/:page" [page] ((keyword page) page-handlers)))

(def app-handler-dispatch
  (handler/site page-handler-dispatch))


;; I could almost imagine traversal like zope/pyramid working in this
;; context. probably accomplished by middleware and then slammed on
;; the request, would a multi-method work or be beneficial?

(def app app-handler-dispatch)
