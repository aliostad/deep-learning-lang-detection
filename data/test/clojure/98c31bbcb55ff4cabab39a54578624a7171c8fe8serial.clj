(ns slimer-serial.transport.serial
  (:require [slimer-serial.config :as config]
            [serial.core :as serial])
  (:import [java.io BufferedReader InputStreamReader InputStream]))

(def ^:private serial-port (serial/open config/port :baud-rate config/baud-rate))

(defn- listener
  [handler]
  (fn [^InputStream in-stream]
    (let [buff-reader (BufferedReader. (InputStreamReader. in-stream))]
      (handler (.readLine buff-reader)))))

(defn gets
  [handler]
  (serial/listen serial-port (listener handler)))

(defn write
  [message]
  (serial/write serial-port (.getBytes message)))
