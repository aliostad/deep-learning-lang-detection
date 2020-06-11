(ns obd.serial
  (:require [manifold.stream :as s]
            [serial.util :as su]
            [serial.core :as ser]))

(def ^:dynamic odbii "/dev/tty.OBDII-SPP")

(defn open-serial
  ([] (open-serial (s/stream)))
  ([stream] (open-serial stream serial-port))
  ([stream serial-port]
   (go
     (let [port (ser/listen! (ser/open serial-port)
                             (fn [^java.io.InputStream in-stream]
                               (s/put! (.read in-stream) stream))
                             false)]))
   stream))

