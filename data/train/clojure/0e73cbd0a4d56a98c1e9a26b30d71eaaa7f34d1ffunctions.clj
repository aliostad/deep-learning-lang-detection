(ns onyx.plugin.functions
  (:require [hildebrand.channeled :refer [scan!]]
            [hildebrand.streams :as streams]
            [hildebrand.streams.channeled :as channeled]
            [clojure.core.async :as c]))

(defn transform-stream-item [record]
  (if-not (= record :done)
    (case (first record)
     :insert {:event-type :insert :new (second record)}
     :modify {:event-type :modify :old (second record) :new (last record)}
     :delete {:event-type :delete :deleted (second record)})
    record))

(def stream-xform (comp (map transform-stream-item)))

(defmulti <results-channel (fn [operation _ _ _] operation))

(defmethod <results-channel :scan [_ conn table chan]
  (scan! conn table {} {:chan chan}))

(defmethod <results-channel :stream [_ conn table chan]
  (let [stream-arn (streams/latest-stream-arn!! conn table)
        shard-id (-> (streams/describe-stream!! conn stream-arn) :shards last :shard-id)
        to-chan (c/chan 1 stream-xform)]
    (c/pipe chan to-chan)
    (channeled/get-records! conn stream-arn shard-id :trim-horizon {} {:chan to-chan})))
