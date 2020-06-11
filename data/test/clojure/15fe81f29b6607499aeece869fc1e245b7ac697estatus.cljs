(ns ivr.routes.status
  (:require [ivr.routes.url :as url]
            [ivr.services.routes.dispatch :as routes-dispatch]))


(def call-status-url
  (get-in url/config [:apis :v1 :status :call]))

(def call-dial-status-url
  (get-in url/config [:apis :v1 :status :dial]))


(def resolve-call-middleware
  (routes-dispatch/dispatch [:ivr.call/resolve {:create? false
                                                :fail? false}]))


(def call-status-route
  (routes-dispatch/dispatch [:ivr.call/status-route]))

(def call-dial-status-route
  (routes-dispatch/dispatch [:ivr.call/dial-status-route]))


(defn init [router]
  (doto router

    (.use call-status-url resolve-call-middleware)
    (.post call-status-url call-status-route)

    (.use call-dial-status-url resolve-call-middleware)
    (.post call-dial-status-url call-dial-status-route)))
