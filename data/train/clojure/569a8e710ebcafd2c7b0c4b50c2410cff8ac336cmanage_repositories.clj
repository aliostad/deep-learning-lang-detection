(ns forecast.repository.manage-repositories
  (:require ;; [clojure.string :as string]
            ;; [clojure.java.io]
            ;; [clojure.tools.logging :as log]
            ;; [clojure.core.async :refer [go]]

            ;; [forecast.helpers :as h]
            ;; [forecast.metrics :as metrics]
            [forecast.repository.ip-locator :as ip]
            [forecast.repository.location-forecast :as location]

            [forecast.repository.storage.memory :as memory]
            [forecast.repository.storage.aerospike :as aero]
            [forecast.repository.storage.datascript :as datascript]

            [forecast.repository.locate-service.ipinfo-io :as ipinfo-io]
            [forecast.repository.locate-service.random :as random-locate]

            [forecast.repository.forecast-service.openweathermap-org :as openweather]
            [forecast.repository.forecast-service.random :as random-forecast]
            ))

(defn use-memory-storage
  []
  (reset! ip/ip-repo (memory/build-repository "ip"))
  (reset! location/location-repo (memory/build-repository "location")))

(defn use-aerospike-storage
  []
  (reset! ip/ip-repo (aero/build-repository "ip"))
  (reset! location/location-repo (aero/build-repository "location")))

(defn use-datascript-storage
  []
  (reset! ip/ip-repo (datascript/build-repository "ip"))
  (reset! location/location-repo (datascript/build-repository "location")))

;; services

(defn use-random-services []
  (reset! ip/locate-service #'random-locate/find-location)
  (reset! location/forecast-service #'random-forecast/find-forecast))

(defn use-live-services []
  (reset! ip/locate-service #'ipinfo-io/find-location)
  (reset! location/forecast-service #'openweather/find-forecast))

