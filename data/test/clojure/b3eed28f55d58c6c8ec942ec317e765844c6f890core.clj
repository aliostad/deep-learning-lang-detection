(ns bs-bug.core
  (:require
   [clojure.java.io :as io]
   [byte-streams :as bs]
   [manifold.stream :as s]))

(defn get-buffers
  "Get text in 3 buffers"
  []
  (bs/to-byte-buffers
   (java.io.ByteArrayInputStream. (.getBytes (slurp (io/resource "text.txt"))))
   {:chunk-size 1024}))

(defn reduce-stream [bufs]
  (deref
   (s/reduce
    (fn [acc buf]
      (conj acc "yep!"))
    []
    bufs)))

;; On my machine, this hangs

(reduce-stream (get-buffers))

;; After a while of playing around, I discovered this approach
;; worked. It returns a stream that explicitly closes.

(defn ->closing-stream [bufs]
  (let [s (s/stream 100)]
    (doseq [b bufs]
      (s/put! s b))
    (s/close! s)
    s))

;; Now the reduce-stream returns the expected result

(reduce-stream
 (->closing-stream (get-buffers)))
