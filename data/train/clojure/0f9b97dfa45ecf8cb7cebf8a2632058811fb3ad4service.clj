(ns googlecloud.bigquery.service
  (:import [com.google.api.services.bigquery BigqueryScopes Bigquery$Builder]
           [com.google.api.client.googleapis.javanet GoogleNetHttpTransport]
           [com.google.api.client.json.jackson2 JacksonFactory])
  (:require [clojure.java.io :as io]))

(def scopes {:manage BigqueryScopes/BIGQUERY
             :insert BigqueryScopes/BIGQUERY_INSERTDATA})

(defn service [credentials & {:keys [application]
                              :or   {application "https://github.com/pingles/googlecloud"}}]
  (let [transport    (GoogleNetHttpTransport/newTrustedTransport)
        json-factory (JacksonFactory. )]
    (.build (doto (Bigquery$Builder. transport json-factory credentials)
              (.setApplicationName application)))))
