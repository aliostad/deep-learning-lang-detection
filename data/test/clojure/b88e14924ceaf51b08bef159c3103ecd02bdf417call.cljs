(ns ivr.routes.call
  (:require [cljs.nodejs :as nodejs]
            [ivr.routes.url :as url]
            [ivr.services.routes.dispatch :as routes-dispatch]))

(defonce express (nodejs/require "express"))


(def base-url
  (str (get-in url/config [:apis :v1 :link])
       (get-in url/config [:apis :v1 :call :link])))


(def call-context-url
  (get-in url/config [:apis :v1 :call :context]))


(def resolve-call-middleware
  (routes-dispatch/dispatch [:ivr.call/resolve {:create? false}]))


(def call-context-route
  (routes-dispatch/dispatch [:ivr.call/context-route]))


(def router
  (doto (.Router express #js {:mergeParams true})

    (.use call-context-url resolve-call-middleware)
    (.get call-context-url call-context-route)))


(defn init [app]
  (doto app
    (.use base-url router)))
