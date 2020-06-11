(ns sphere-hello-api.product 
  (:use [carica.core])
  (:require [clj-http.client :as client]
            [clojure.data.codec.base64 :as base64]
            [clojure.data.json :as json]))

(defn encode [s]
  (String. (base64/encode (.getBytes s)) "UTF-8"))
    
(defn login 
  "Retrieves oauth access token"
  []
  (let [auth-token (str "Basic " (encode (str (config :client-id) ":" (config :client-secret))))
        auth-response (client/post (config :auth-api-url)
                        {:headers {"Authorization" auth-token
                                   "Content-Type" "application/x-www-form-urlencoded"}
                         :body (str "grant_type=client_credentials&scope=manage_project:" (config :project-key))})]
    ((json/read-str (:body auth-response)) "access_token")))

(defn -main [& args]
  (let [access-token (login)
        products-response (client/get 
                            (str (config :api-url) "/" (config :project-key) "/product-projections")
                            {:headers {"Authorization" (str "Bearer " access-token)}})]
    (println "Number of products:" ((json/read-str (:body products-response)) "total"))))