(ns ivr.routes.config
  (:require [cljs.nodejs :as nodejs]
            [ivr.routes.url :as url]
            [ivr.services.config :as config]
            [ivr.services.routes.dispatch :as routes-dispatch]
            [re-frame.core :as re-frame]))

(defonce express (nodejs/require "express"))

(def base-url
  (str (get-in url/config [:apis :v1 :link])
       (get-in url/config [:apis :v1 :config :link])))

(def explain-url
  (get-in url/config [:apis :v1 :config :explain]))

(def explain-route
  (routes-dispatch/dispatch [:ivr.config/explain-route]))

(def router
  (doto (.Router express)
    (.get explain-url explain-route)))

(defn init [app]
  (doto app
    (.use base-url router)))
