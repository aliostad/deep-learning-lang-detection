(ns hypedloglog.arbiter
  (:require [aleph.http :as http]
            [aleph.tcp :as tcp]
            [manifold.deferred :as d]
            [manifold.stream :as s]
            [hypedloglog.local :as hl]
            [hypedloglog.concurrent :as hc]))

;; An arbiter owns a log and things have to ask permission to write to it
;; Internally it uses refs to manage concurrent updates
;; The interface takes manifold streams

(defn announce-tx
  "Announces a transaction to a stream"
 [stream tx-id tx]
 (put! stream {:event :transaction :tx-id tx-id :tx tx}))

(defn announce-block
  "Announces a block to a stream"
  [stream block-id block]
  (put! stream {:event :block :block-id block-id :covers (hl/block-interval block)}))

(defrecord acll
  "Arbitrated concurrent loglog"
  [next-client-id clients ll broadcast-stream]
  (try-tx [{:keys [ll]} as-of guards actions]
    (hc/try-tx ll as-of guards actions))
  (listen [{:keys [broadcast-stream]} stream]
    (s/connect broadcast-stream stream)))

(defn make-acll [ll]
  {:next-client-id (ref 1)
   :ll (ref ll)
   :broadcast-stream (s/stream)})

(defn load-acll
  "Loads an acll"
  [])

