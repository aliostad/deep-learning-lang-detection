(ns ivr.routes.twimlet
  (:require [cljs.nodejs :as nodejs]
            [ivr.models.twimlet]
            [ivr.routes.url :as url]
            [ivr.services.routes.dispatch :as routes-dispatch]))

(defonce express (nodejs/require "express"))


(def base-url
  (str (get-in url/config [:apis :v1 :link])
       (get-in url/config [:apis :v1 :twimlet :link])))

(def loop-play-url
  (get-in url/config [:apis :v1 :twimlet :loop-play]))

(def welcome-url
  (get-in url/config [:apis :v1 :twimlet :welcome]))


(def loop-play-route
  (routes-dispatch/dispatch [:ivr.twimlet/loop-play-route]))

(def welcome-route
  (routes-dispatch/dispatch [:ivr.twimlet/welcome-route]))


(def router
  (-> (.Router express)
      (doto (.all loop-play-url loop-play-route)
        (.all welcome-url welcome-route))))


(defn init
  [app]
  (doto app
    (.use base-url router)))
