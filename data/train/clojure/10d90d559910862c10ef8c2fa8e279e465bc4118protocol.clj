(ns obd.protocol
  (:require
   [manifold.stream :as s]
   [gloss.core :refer [defcodec]:as g]
   [gloss.io :as io]))

(defcodec at-protocol
  (g/string :utf-8 :delimiters ["\n" "\r" "\r\n"]))

; http://www.elmelectronics.com/obdic.html#ELM327v21
(defcodec elm327-protocol-v2_1
  (g/repeated (g/string :utf-8)
              :delimiters [">"]))

(defn wrap-duplex-stream
  [protocol s]
  (let [out (s/stream)]
    (s/connect
     (s/map #(io/encode at-protocol %) out)
     s)
    (s/splice
     out
     (io/decode-stream s elm327-protocol-v2_1))))

(def wrap-stream-with-at-protocol (partial wrap-duplex-stream at-protocol))

