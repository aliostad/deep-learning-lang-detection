(ns redlobster.stream
  (:require-macros [cljs.node-macros :as n])
  (:require [redlobster.promise :as p]
            [redlobster.events :as e])
  (:use [cljs.node :only [log]])
  (:use-macros [redlobster.macros :only [promise when-realised]]))

(n/require "stream" Stream)
(n/require "fs" [createReadStream createWriteStream])

(defprotocol IStream
  (readable? [this])
  (writable? [this])
  (set-encoding [this encoding])
  (pause [this])
  (resume [this])
  (destroy [this])
  (pipe [this destination])
  (pipe [this destination options])
  (write [this data])
  (write [this data encoding])
  (end [this])
  (end [this data])
  (end [this data encoding])
  (destroy-soon [this]))

(defn stream? [v]
  (satisfies? IStream v))

(extend-protocol IStream
  Stream
  (readable? [this] (.-readable this))
  (writable? [this] (.-writable this))
  (set-encoding [this encoding] (.setEncoding this encoding))
  (pause [this] (.pause this))
  (resume [this] (.resume this))
  (destroy [this] (.destroy this))
  (pipe [this destination] (.pipe this destination))
  (pipe [this destination options] (.pipe this destination (clj->js options)))
  (write [this data] (.write this data))
  (write [this data encoding] (.write this data encoding))
  (end [this] (.end this))
  (end [this data] (.end this data))
  (end [this data encoding] (.end this data encoding))
  (destroy-soon [this] (.destroySoon this)))

(defn read-file [path]
  (createReadStream path))

(defn write-file [path]
  (createWriteStream path))

(defn- append-data [current data encoding]
  (let [data (if (instance? js/Buffer data)
               (.toString data encoding)
               data)]
    (str current data)))

(defn read-stream [stream & [encoding]]
  (promise
   (let [content (atom "")
         encoding (or encoding "utf8")]
     (e/on stream :error #(realise-error %))
     (e/on stream :data
           (fn [data]
             (swap! content append-data data encoding)))
     (e/on stream :end #(realise @content)))))

(defn read-binary-stream [stream]
  (promise
   (let [arrays #js[]]
     (e/on stream :error realise-error)
     (e/on stream :data
           (fn [data]
             (.push arrays data)))
     (e/on stream :end #(realise (js/Buffer.concat arrays))))))

(defn write-stream [stream data & [encoding]]
  (promise
   (e/on stream :close #(realise nil))
   (e/on stream :error #(realise-error %))
   (cond
    (stream? data) (.pipe data stream)
    (instance? js/Buffer data)
    (do
      (.write stream data)
      (.end stream))
    (string? data)
    (do
      (if encoding
        (.write stream data encoding)
        (.write stream data))
      (.end stream))
    :else
    (do
      (.end stream)
      (realise-error :redlobster.stream/unknown-datatype)))))
