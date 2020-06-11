(ns dashboarder.core
  (:require [clj-http.client :as client]
            [cheshire.core :as cheshire]))

(def base-url (str "https://metrics-api.librato.com/v1"))

(defn get-resource [creds resource]
  (let [results (client/get (str base-url "/" (name resource)) {:basic-auth [(:user creds) (:pass creds)] :as :json})]
    ((keyword resource) (:body results))))

(defn resource-map [col primary-key]
  (let [updated-col (map (fn [x] [(keyword (x primary-key)) x]) col)]
    (into {} updated-col)))

(defn instrument-request-body [definition]
  (let [instrument-name (name (first definition))
        metrics (rest definition)
        named-metrics (map name metrics)
        streams (map (fn [x] {:metric x :source "*"}) named-metrics)]
    {:name instrument-name :streams streams}))

(defn create-instrument [creds definition]
  (let [response (client/post (str base-url "/instruments")
                              {:basic-auth [(:user creds) (:pass creds)]
                               :content-type :json
                               :body (cheshire/generate-string (instrument-request-body definition))
                               :as :json
                               :throw-entire-message? true})]
    (:body response)))

(defn ensure-instrument [creds instrument-map definition]
  (let [instrument-name (first definition)]    
    (if-let [instrument (instrument-map instrument-name)]
      instrument
      (create-instrument creds definition))))

(defn dashboard-request-body [creds dashboard-name instrument-definitions]
  (let [instrument-map (resource-map (get-resource creds :instruments) :name)
        instruments (map (fn [x] (ensure-instrument creds instrument-map x)) instrument-definitions)
        instrument-ids (map :id instruments)]
    {:name dashboard-name :instruments instrument-ids}))

(defn create-dashboard [creds dashboard-name instrument-definitions]
  (let [response (client/post (str base-url "/dashboards")
                              {:basic-auth [(:user creds) (:pass creds)]
                               :content-type :json
                               :body (cheshire/generate-string (dashboard-request-body dashboard-name instrument-definitions))
                               :as :json})]
    (:body response)))

(defn ensure-dashboard [creds dashboard-map dashboard-name instrument-definitions]
  (if-let [dashboard (dashboard-map dashboard-name)]
    dashboard
    (let [instrument-map (resource-map (get-resource creds :instruments) :name)
          instruments (map (fn [x] (ensure-instrument creds instrument-map x)) instrument-definitions)
          instrument-ids (map :id instruments)]
      (create-dashboard creds dashboard-name instrument-definitions))))

(defn compose [creds data]
  (let [dashboard-map (resource-map (get-resource creds :dashboards) :name)]
    (for [k (keys data)] (ensure-dashboard creds dashboard-map k (k data)))))