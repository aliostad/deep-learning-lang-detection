(ns iq-streams.metadata
  (:require [iq-streams.utils :as u])
  (:import org.apache.kafka.common.serialization.StringSerializer))

(defn- instance-store-info
  [metadata]
  (u/obj->map metadata
            :host .host
            :port .port
            :state-store-names .stateStoreNames))

(defn- instances-store-info
  [metadata]
  (-> metadata
      .iterator
      iterator-seq
      (#(reduce (fn [agg metadata]
                  (merge agg (instance-store-info metadata)))
                []
                %))))

(defn streams-metadata
  [stream]
  (-> stream
      .allMetadata
      instances-store-info))

(defn metadata-for-store
  [stream store]
  (-> stream
      (.allMetadataForStore store)
      instances-store-info))

(defn metadata-for-key
  ([stream store k]
   (metadata-for-key stream store k (StringSerializer.)))
  ([stream store k serilizer]
   (-> stream
       (.metadataForKey store k serilizer)
       instance-store-info)))
