(ns com.rymndhng.kinesis.stream
  (:require [clojure.spec :as s]
            [clojure.spec.test :as spec.test]
            [clojure.tools.logging :as log])
  (:import com.amazonaws.services.kinesis.AmazonKinesisClient
           com.amazonaws.services.kinesis.model.GetRecordsRequest
           com.amazonaws.services.kinesis.model.Record
           com.amazonaws.services.kinesis.model.ResourceInUseException))

;; -- Domain Bits  -------------------------------------------------------------
(defn stream-record? [it] (instance? Record it))

(defn maybe-transform [f]
  (fn [record]
    (if (stream-record? record)
      (f (-> record .getData .array))
      record)))

(def transform-smile (maybe-transform #(cheshire.core/parse-smile % true)))
(def transform-cbor (maybe-transform #(cheshire.core/parse-cbor % true)))
(def transform-json (maybe-transform #(cheshire.core/parse-stream % true)))

(s/def ::kinesis-client #(instance? AmazonKinesisClient %))
(s/def ::shard-iterator string?)

(s/fdef get-shard-iterator!
  :args (s/cat :client ::client :stream-name string?)
  :ret ::shard-iterator)

(defrecord StreamExhausted [next-shard-iterator])

(defn exhausted? [v]
  (instance? StreamExhausted v))

(defn shard-iterator->lazy-seq
  "Takes an AWS Client, a shard-iterator and returns a lazy sequence of the
  records in this shard.

  When the stream is paused because it is up to date:
  - a StreamExhausted
  "
  ([client shard-iterator]
   (shard-iterator->lazy-seq client shard-iterator {::records 10
                                                    ::millis 60000}))
  ([client shard-iterator threshold-heuristics]
   (let [request (-> (GetRecordsRequest.)
                   (.withShardIterator shard-iterator)
                   (.withLimit (int (::records threshold-heuristics))))
         response (.getRecords client request)

         millis-behind-latest (.getMillisBehindLatest response)
         next-shard-iterator  (.getNextShardIterator response)
         records (.getRecords response)]

     (printf "Advanced shard: %h. Delay with head of stream: [%s]\n"
       next-shard-iterator millis-behind-latest)

     (lazy-cat
       records
       (if (and (> (::records threshold-heuristics) (count records))
                (> (::millis threshold-heuristics) millis-behind-latest))
         (list (->StreamExhausted next-shard-iterator))
         (lazy-seq (shard-iterator->lazy-seq client next-shard-iterator)))))))


;; -- Stream Handling Strategy  ------------------------------------------------
(defn until-exhausted
  "Returns a transducer that stops when the stream is exhausted.

  When passed an atom, will write the final StreamExhausted event into the atom.
  "
  ([] (take-while (comp not exhausted?)))
  ([atm]
   (fn [rf]
     (fn
       ([] (rf))
       ([result] (rf result))
       ([result input] (if (exhausted? input)
                         (do (reset! atm (:next-shard-iterator input))
                             (reduced result))
                         (rf result input)))))))

(defn perpetually [stream-seq delay-between-exhaustion]
  "Takes a stream and realizes the values in the stream perpetually.

  If an exhaustion record is
  "
  (let [result (last stream-seq)]
    (when (exhausted? result)
      (Thread/yield)
      (Thread/sleep delay-between-exhaustion)
      (recur
        (shard-iterator->lazy-seq (:client result) (:next-shard-iterator result))
        delay-between-exhaustion))))

(defn get-shard-iterator!
  "Gets a shard iterator of the first shard"
  [client stream-name]
  (let [shard (-> (.describeStream client stream-name)
                .getStreamDescription
                .getShards
                first)

        shard-id (.getShardId shard)
        starting-sequence-number (-> shard
                                   .getSequenceNumberRange
                                   .getStartingSequenceNumber)]
    (.getShardIterator (.getShardIterator client
                         stream-name
                         shard-id
                         "AT_SEQUENCE_NUMBER"
                         starting-sequence-number))))


(defn kinesis-stream
  [client stream-name]
  (let [shard-iterator (get-shard-iterator! client stream-name)]
    (shard-iterator->lazy-seq client shard-iterator)))


(defmethod print-method com.amazonaws.AmazonWebServiceClient [inst w]
  (.write w (str "#<AWSClient:" (.getServiceName inst) ">")))

(comment
  (spec.test/instrument)

  ;; Use kinesalite for equivalent API
  (def client (doto (AmazonKinesisClient.) (.setEndpoint "http://localhost:4567")))
  (def stream-name "foo")
  (def stream (try (.createStream client stream-name (int 1))
                   ::created
                   (catch ResourceInUseException e
                     ::already-exists)))

  (def my-stream (kinesis-stream client "foo"))

  ;; transducible
  (eduction (comp until-exhausted (map transform-smile)) my-stream)

  (map transform-smile my-stream)

  (def task (future (perpetually (eduction (map #(println "Processing: " %))
                                           (map transform-smile)
                                           (kinesis-stream client "foo"))
                      10000)))

  (def the-last (last (map transform-smile my-stream)))

  (def processor)

  my-stream

  (type the-last)


  )
