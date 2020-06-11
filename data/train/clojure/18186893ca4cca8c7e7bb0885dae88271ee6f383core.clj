(ns conduit.core
  (:require
   [rn.clorine.pool     :as pool])
  (:import
   [org.apache.commons.io IOUtils]
   [java.io PipedInputStream PipedOutputStream ByteArrayInputStream]))


(defn close-pipe [pipe-ostream]
  (try
   (.flush pipe-ostream)
   (.close pipe-ostream)
   (catch Exception ex
     ;; What to do here? log?
     )))

(defn pipe-writer [^PipedOuputStream pipe func]
  (Thread.
   (fn []
     (func pipe)
     (close-pipe pipe))))

(defn pipe-reader [^PipedInputStream pipe func]
  (Thread.
   (fn []
     (func pipe))))

(def *stream-filter-wrappers*
     {:gzip (fn [ostream] (java.util.zip.GZIPOutputStream. ostream))})

(defn apply-standard-filter [filter stream]
  (if-let [wrapper-fn (get *stream-filter-wrappers* filter)]
    (wrapper-fn stream)
    ;; NB: maybe just raise here?
    stream))

(defn apply-stream-filters [ostream filters]
  (reduce (fn [stream stream-filter]
            (cond (keyword? stream-filter)
                  (apply-standard-filter stream-filter stream)

                  (fn? stream-filter)
                  (stream-filter stream)

                  :else stream)
            )
          ostream
          filters))


(defn pipeline [ostream-producer-fn istream-consumer-fn & stream-filters]
  (let [producer-istream (PipedInputStream.)
        producer-ostream (apply-stream-filters
                          (PipedOutputStream. producer-istream)
                          stream-filters)
        producer         (pipe-writer producer-ostream ostream-producer-fn)
        consumer         (pipe-reader producer-istream istream-consumer-fn)]
    (.start producer)
    (.start consumer)
    {:producer producer
     :consumer consumer}))


(defn create-conduit [& args]
  (fn [producer consumer & stream-filters]
    (apply pipeline producer consumer stream-filters)))

(defn initialize []
  (pool/register-pool
   :core-conduits
   (pool/make-factory {:make-fn create-conduit})))

(defn send! [data-producer data-consumer & stream-filters]
  (pool/with-instance [conduit :core-conduits]
    (.join (:consumer (apply conduit data-producer data-consumer stream-filters)))))


(initialize)