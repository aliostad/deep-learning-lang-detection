(ns clj-codetip.streams.limited-input-stream)

(gen-class
 :name clj-codetip.streams.limited-input-stream.LimitedInputStream
 :state state
 :init init
 :extends java.io.InputStream
 :constructors {[java.io.InputStream Long] []}
 :prefix "lis-"
 :main false)


(defn lis-init [stream max]
  [[] (atom {:stream stream
             :read-count 0
             :max max})])


(defn- get-field [this key]
  (@(.state this) key))


(defn- set-field [this key value]
  (swap! (.state this) into {key value}))


(defn lis-available [this]
  (.available (get-field this :stream)))


(defn lis-close [this]
  (.close (get-field this :stream)))


(defn lis-mark [this limit]
  (.mark (get-field this :stream) limit))


(defn lis-mark-supported [this]
  (.mark-supported (get-field this :stream)))


(defn lis-read
  ([this]
   (.read this (byte-array 1)))
  ([this buf]
   (.read this buf (int 0) (count buf)))
  ([this buf off len]
   (let [state         @(.state this)
         current-count (:read-count state)
         max           (:max state)]
     (if (> (+ current-count len) max)
       (throw (java.io.IOException. "Exceeded stream limit")))
     (let [read-count (.read (:stream state) buf off len)]
       (if (= read-count -1)
         read-count
         (set-field this :read-count (+ read-count current-count)))
       read-count))))


(defn lis-reset [this]
  (.reset (get-field this :stream)))


(defn lis-skip [this n]
  (.skip (get-field this :stream) n))
