(ns er-cassandra.util.stream
  (:require
   [cats.context :refer [with-context]]
   [cats.core :refer [mlet return ->>=]]
   [cats.labs.manifold :refer [deferred-context]]
   [manifold.deferred :as d]
   [manifold.stream :as s]))

(defn catch-value
  "given a Deferred value catch errors and return Deferred<Throwable>
   or if not in the error-state, just return Deferred<value>. for plain
   values, just return the value"
  [v-or-dv]
  (if (d/deferred? v-or-dv)
    (d/catch v-or-dv (fn [e] e))
    v-or-dv))

(defn keep-error
  "reducer fn which keeps the first Throwable encountered,
   otherwise the last value encountered"
  [curr nxt]
  (if (instance? Throwable curr)
    curr
    nxt))

(defn throw-throwable
  "if the Deferred<value> is a Throwable, throw it"
  [dv]
  (-> dv
      (d/chain (fn [v]
                 (if (instance? Throwable v)
                   (throw v)
                   v)))))

(defn keep-stream-error
  "given a stream of Deferred<value|Throwable> reduce it to the first
   Throwable or (f final-value). the default f just returns nil"
  ([strm] (keep-stream-error strm (constantly nil)))
  ([strm f]
   (as-> strm %
     (s/map catch-value %)
     (s/realize-each %)
     (s/reduce keep-error nil %)
     (throw-throwable %)
     (d/chain % f))))

;; TODO this closes the stream as soon as it encounters an error - might be
;; better for it to consume the whole stream like keep-stream-error, but
;; copy the stream to a new stream up to the first error ?
(defn stream->seq-with-error
  "realize a Stream<value> to a Seq<value>, throwing an Exception
   and closing the stream if a Throwable value is encountered"
  ([strm] (stream->seq-with-error strm 5000))
  ([strm timeout-ms]
   (as-> strm %
     (s/map catch-value %)
     (s/realize-each %)
     (s/stream->seq %)
     (map (fn [v]
            (if (instance? Throwable v)
              (throw v)
              v))
          %))))
