; Copyright (c) Gunnar Völkel. All rights reserved.
; The use and distribution terms for this software are covered by the
; Eclipse Public License 1.0 (http://opensource.org/licenses/eclipse-1.0.php)
; which can be found in the file epl-v1.0.txt at the root of this distribution.
; By using this software in any fashion, you are agreeing to be bound by
; the terms of this license.
; You must not remove this notice, or any other, from this software.

(ns frost.stream-freezer
  (:require
    [clojure.java.io :as io]
    [clojure.options :refer [defn+opts, defn+opts-, ->option-map]]
    [frost.util :refer [conditional-wrap]]
    [frost.version :as v]
    [frost.kryo :as kryo]
    [frost.compression :as compress])
  (:import
    (java.io Closeable EOFException OutputStream InputStream DataOutputStream DataInputStream)
    (com.esotericsoftware.kryo Kryo KryoException)
    (com.esotericsoftware.kryo.io Output Input)))


(defprotocol IFreeze
  (freeze [this, obj] "Serialize a given object."))

(defprotocol IDefrost
  (defrost [this] "Deserialize the next object."))



(deftype StreamFreezer [^Kryo kryo, ^Output out, locking?]
    
  Closeable
  (close [this]
    (conditional-wrap locking? (locking this %)
      (.flush out)
      (.close out)))
  
  IFreeze
  (freeze [this, obj]
    (conditional-wrap locking? (locking this %)
      (.writeClassAndObject kryo, out, obj)
      (.flush out))))


(defn+opts ^StreamFreezer create-freezer
  "Creates a stream freezer to serialize data into the given output stream.
  The stream freezer can use compression. The stream freezer can be created in a thread-safe or non-thread-safe mode.
  <compressed>Specifies whether compression of the data is used.</>
  <locking>Determines whether locking should be use to make the stream freezer thread-safe.</>
  "
  [^OutputStream output-stream | {compressed false, locking true} :as options]
  ; create kryo configured by given parameters
  (let [kryo (kryo/create-specified-kryo options),
        output-stream (cond-> output-stream
                        ; activate compression if specified
                        compressed (compress/wrap-compression options))]
      (StreamFreezer. kryo,
        (Output. ^OutputStream output-stream), 
        locking)))



(deftype StreamDefroster [^Kryo kryo, ^Input in, locking?]
    
  Closeable
  (close [this]
    (conditional-wrap locking? (locking this %)
      (.close in)))
  
  IDefrost
  (defrost [this]
    (conditional-wrap locking? (locking this %)
      (.readClassAndObject kryo, in))))


(defn+opts ^StreamDefroster create-defroster
  "Creates a stream defroster to read data from the given stream.
  The stream defroster can be created in a thread-safe or non-thread-safe mode.
  <compressed>Specifies whether compression of the data is used.</>
  <locking>Determines whether locking should be use to make the stream freezer thread-safe.</>"
  [^InputStream input-stream | {compressed false, locking true} :as options]
  ; create kryo configured by given parameters
  (let [kryo (kryo/create-specified-kryo options),
        input-stream (cond-> input-stream
                       ; activate compression if specified
                       compressed (compress/wrap-compression options))]
    (StreamDefroster. kryo,
      (Input. ^InputStream input-stream),
      locking)))