(ns com.theinternate.reformatory.experimental.service
  (:require [cognitect.transit :as transit])
  (:import (java.io PipedInputStream
                    PipedOutputStream)
           (io.grpc MethodDescriptor$Marshaller MethodDescriptor MethodDescriptor$MethodType)))

(def ^:private transit-marshaller
  (reify MethodDescriptor$Marshaller
    (parse [_ stream]
      (-> stream (transit/reader :json) transit/read))
    (stream [_ value]
      (let [in (PipedInputStream. 4096)]
        (with-open [out (PipedOutputStream. in)]
          (-> out (transit/writer :json) (transit/write value)))
        in))))

(defn method-descriptor
  ^MethodDescriptor [service-name method-name]
  (MethodDescriptor/create MethodDescriptor$MethodType/UNARY
                           (MethodDescriptor/generateFullMethodName service-name method-name)
                           transit-marshaller
                           transit-marshaller))