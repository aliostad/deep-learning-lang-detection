(ns ^{:doc "This is the main view. It receives requests from the
            controller and fetches information from the model.

            The main views make use of nested components."}
      
  track.handlers

  (:require [track.json :as json])
  (:use [ring.util.response :only [redirect-after-post]]
        [track.model]))

(defn registration
  [{{:strs [username password name]} :form-params}]
  (let [status
        (try
          (do (store (create-user {:username username
                                   :password password
                                   :name name})))
          (catch RuntimeException e
            {:error (.. e getCause getMessage)})
          (catch Exception e
            {:error (. e getMessage)}))]
    (if (contains? status :error)
      (assoc (redirect-after-post "/register")
        :flash {:alert-info (:error status)})
      (assoc (redirect-after-post "/")
        :flash {:alert-info "User created."}))))

(defn new-device
  [{{uid :user_id} :basic-authentication {:strs [location]} :params}]
  (let [status
        (try
          (do (store (create-device {:owner uid :location location})))
          (catch RuntimeException e
            {:error (.. e getCause getMessage)})
          (catch Exception e
            {:error (. e getMessage)}))]
    (assoc (redirect-after-post "/manage/devices")
      :flash {:alert-info (if (contains? status :error)
                            (:error status)
                            "Device created.")})))

(defn delete-device
  [{user :basic-authentication} device_id]
  (let [status
        (try
          (delete (create-device {:device_id device_id}) user)
          (catch RuntimeException e
            {:error (.. e getCause getMessage)})
          (catch Exception e
            {:error (. e getMessage)}))]
    (assoc (redirect-after-post "/manage/devices")
      :flash {:alert-info (if (contains? status :error)
                            (:error status)
                            "Device deleted.")})))

(defn delete-series
  [{user :basic-authentication} series_id]
  (let [status
        (try
          (delete (create-series {:series_id series_id}) user)
          (catch RuntimeException e
            {:error (.. e getCause getMessage)})
          (catch Exception e
            {:error (. e getMessage)}))]
    (assoc (redirect-after-post "/manage/series")
      :flash {:alert-info (if (contains? status :error)
                            (:error status)
                            "Series deleted.")})))

(defn store-measurements
  [{params :json-params}]
  (when-not (nil? params)
    (json/store-measurements params)))

(defn fetch-measurements
  [{params :query-params} series-id]
  (json/fetch-measurements series-id params))
