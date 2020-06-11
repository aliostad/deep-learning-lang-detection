(ns memjore.views.logintest
  (:require [noir.session :as session])
  (:use [midje.sweet]
        [noir.core :only [url-for]]
        [noir.util.test]
        [memjore.views.login]))


;;(fact "User sees username and password fields on / page"
;;  (send-request "/") )
(fact "User is not logged in when session username is nil"
  (with-noir
    (do
      (session/clear!)
      (logged-in?) => false)))


(fact "User is logged in when session username is not nil"
  (with-noir
    (do
      (session/put! :username "somebody")
      (logged-in?) => true)))


(fact "User can log out"
  (with-noir
    (.contains (:body (send-request  "/log-out"))
             "Logged out")  => true))


(fact "When user is logged in, user is redirected to manage home page"
  (with-noir
    (let [login-result    (send-request [:post (url-for login-authentication)]
                                        {:username "admin" :password "password"})]
      (get (:headers login-result) "Location")  => "/manage/home")))

