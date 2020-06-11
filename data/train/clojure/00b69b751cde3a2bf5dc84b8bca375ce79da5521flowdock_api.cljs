(ns flowdock_api
  (:require [webfunctions :as wf]))

(enable-console-print!)

(defonce remote (js/require "remote"))

(defonce request (.require remote "request"))

(defonce client-oauth2 (.require remote "simple-oauth2"))

(def flowdock-app-id
  "79b2bd6aaca74a2b0d93bf933e338e97dc6336552876202f73e81fffcf1ba8f3")

(def secret
  "0e1cf579e7b4efb5ea617301bf429e4b070a8296637f25cfc408b730a32b1ebe")

(def flowdock-oauth
  {
   :clientID "79b2bd6aaca74a2b0d93bf933e338e97dc6336552876202f73e81fffcf1ba8f3"
   :clientSecret "0e1cf579e7b4efb5ea617301bf429e4b070a8296637f25cfc408b730a32b1ebe"
   :site "https://api.flowdock.com/"
   :tokenPath "oauth/authorize"
   :authorizationPath "oauth/token"
   :redirect_uri (wf/fullroute "/auth")
   :scope ["flow","private","manage","profile"]
   :state "MyTotallyUnguessableString"
   })

(defn opts [m keys]
  (clj->js (select-keys m keys)))

(defn oauth2 [auth-map]
  (let [client-opts (opts auth-map [:clientID :clientSecret :site :tokenPath])
        auth-opts (opts auth-map [:redirect_uri :scope :state])
        client (client-oauth2. client-opts)]
    (-> auth-map
        (assoc :client client)
        (assoc :authorizationUri (.authorizeURL (.-authCode client) auth-opts)))))

(defn flowauth [] (oauth2 flowdock-oauth))

(defn code-url [oauth]
  (:authorizationUri oauth))

(defn create-token [oauth callback result]
  (let [token (-> oauth :client .-accessToken (.create result))]
    (println token)
    (callback token)))

(defn get-token [oauth code callback]
  (let [authCode (.-authCode (:client oauth))
        authCodeOpts (clj->js {:code code})]
    (.getToken authCode authCodeOpts (partial create-token oauth callback))))