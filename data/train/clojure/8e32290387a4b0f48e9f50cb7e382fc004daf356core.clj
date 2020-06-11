(ns lost-pet-lambda.core
  (:require [clojure.java.io :as io]
            [cheshire.core :as cheshire]
            [taoensso.timbre :as timbre])
  (:import (java.io InputStream OutputStream)
           (com.amazonaws.services.lambda.runtime Context))
  (:gen-class
    :methods [^:static [handler [java.io.InputStream java.io.OutputStream com.amazonaws.services.lambda.runtime.Context] void]]))

(defn -handler
  [^InputStream input-stream ^OutputStream output-stream ^Context context]
  (with-open [output output-stream
              input  input-stream
              writer (io/writer output)
              reader (io/reader input)]
    (let [request (cheshire/parse-stream reader true)
          pet-name (get-in request [:currentIntent :slots :PetName] "your pet")]
      (timbre/info request)
      (cheshire/generate-stream
        {:dialogAction {:type "Close"
                        :fulfillmentState "Fulfilled"
                        :message {:contentType "PlainText"
                                  :content (str "Thank you, " pet-name " has been added to our database.")}}}
        writer))))
