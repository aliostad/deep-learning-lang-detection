(ns k2nr.docker.utils
  (:require [cheshire.core :as json]
            [clojure.java.io :as io]))

(defn map-keys [f m]
  (into {} (map (fn [[a b]] [(f a) b]) m)))

(defn read-bytes [stream n]
  (let [buf (byte-array n)
        res (.read stream buf 0 n)]
    (if (neg? res)
      nil
      buf)))

(defn ^BigInteger bytes->int
  [^bytes bs & {:keys [little-endian]
                :or {little-endian false}}]
  (let [bs (if little-endian (reverse bs) bs)]
    (biginteger bs)))

(defn bytes->string [bs]
  (apply str (map char bs)))

(defn int->stream-type [n]
  (condp = n
    0 :stdin
    1 :stdout
    2 :stderr
    :unrecognized))

(defn raw-stream->seq [stream]
  (let [header (read-bytes stream 4)]
    (if (nil? header)
      nil
      (let [[stream-type _ _ _] (vec header)
            size (bytes->int (read-bytes stream 4))
            body (bytes->string (read-bytes stream size))
            m  {:stream-type (int->stream-type stream-type)
                :body body}]
        (cons m (lazy-seq (raw-stream->seq stream)))))))

(defn raw-stream-fetcher [stream stream-cb]
  (loop [header (read-bytes stream 4)]
    (when-not (nil? header)
      (let [[stream-type _ _ _] (vec header)
           size (bytes->int    (read-bytes stream 4))
           body (bytes->string (read-bytes stream size))]
       (do
         (stream-cb {:stream-type (int->stream-type stream-type)
                     :body body})
         (recur (read-bytes stream 4)))))))

(defn json-stream->seq [stream & {:keys [as] :or [as :json]}]
  (with-open [r (io/reader stream)]
    (let [line (.readLine r)]
      (if (nil? line)
        nil
        (cons (case as
                :string line
                :json (json/decode line)
                line)
              (lazy-seq (json-stream->seq stream)))))))


(defn json-stream-fetcher [stream stream-cb & {:keys [as] :or [as :json]}]
  (with-open [r (io/reader stream)]
    (loop [line (.readLine r)]
      (when-not (nil? line)
        (do
          (stream-cb (case as
                      :string line
                      :json (json/decode line)
                      line))
          (recur (.readLine r)))))))
