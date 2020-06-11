(ns sound-flour.handler
  (:require
    [compojure.handler :as handler]
    [compojure.core :refer [defroutes GET]]
    [ring.util.response :refer [response content-type]]
    [ring.logger.timbre :as logger.timbre]
    [metrics.ring.expose :refer [expose-metrics-as-json]]
    [metrics.ring.instrument :refer [instrument]]
    [infix.macros :refer [infix from-string]]
    [sound-flour.encoder :refer [audio-stream]]
    [sound-flour.oscillators :refer [sine-wave]])
  (:import
    [sound-flour FunctionInputStream]))

(defn clip [^double d]
  (Math/max -1.0 (Math/min d 1.0)))

(defroutes app-routes
  (GET "/sine-wave" []
    (->
      (comp unchecked-short (partial * 0x7fff) clip (sine-wave 440 0.5))  ; 440 Hz = Middle C
      (FunctionInputStream. 16)
      (audio-stream 8000 16)
      (response)
      (content-type "audio/x-wav")))

  (GET "/8-bit-trip/:expr" [expr]
   (->
     (comp unchecked-byte (from-string [t] expr))
     (FunctionInputStream. 8)
     (audio-stream 8000 8)
     (response)
     (content-type "audio/x-wav"))))

(def app
  (->
    app-routes
    (logger.timbre/wrap-with-logger)
    (expose-metrics-as-json)
    (instrument)
    (handler/api)))
