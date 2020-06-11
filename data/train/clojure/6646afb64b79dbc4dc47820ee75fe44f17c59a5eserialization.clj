(ns rosclj.serialization
  (:require [rosclj.time :as t])
  (:import (java.nio ByteBuffer)
           (rosclj.time Time Duration)))

(def size-t 4)

;; Serialization sizes
(def field-type-size
  {:bool 1
   :int8 1
   :int16 2
   :int32 4
   :int64 8
   :uint8 1
   :uint16 2
   :uint32 4
   :uint64 8
   :float32 4
   :float64 8
   :time 8
   :duration 8})

(def primitive-field-types
  #{:bool :int8 :int16 :int32 :int64
    :uint8 :uint16 :uint32 :uint64
    :float32 :float64 :time :duration})

(defprotocol ISerializedLength
  (is-fixed-size? [this])
  (serialized-length [this obj]))

(extend-type String
  ISerializedLength
  (is-fixed-size? [_] false)
  (serialized-length [str _] (+ size-t (count str))))

(defmulti serialize (fn [mtype _ _] mtype))
(defmulti deserialize (fn [mtype _ & args] mtype))

;; handle signed integers
(defmethod serialize :int8 [_ ^ByteBuffer stream ^long obj]
  (.put stream (byte obj)))
(defmethod deserialize :int8 [_ ^ByteBuffer stream]
  (.get stream))

(defmethod serialize :int16 [_ ^ByteBuffer stream ^long obj]
  (.putShort stream (short obj)))
(defmethod deserialize :int16 [_ ^ByteBuffer stream]
  (.getShort stream))

(defmethod serialize :int32 [_ ^ByteBuffer stream ^long obj]
  (.putInt stream (int obj)))
(defmethod deserialize :int32 [_ ^ByteBuffer stream]
  (.getInt stream))

(defmethod serialize :int64 [_ ^ByteBuffer stream ^long obj]
  (.putLong stream obj))
(defmethod deserialize :int64 [_ ^ByteBuffer stream]
  (.getLong stream))

;; handle unsigned integers
(defmethod serialize :uint8 [_ ^ByteBuffer stream ^long obj]
  (.put stream (byte (bit-and 0x00ff obj))))
(defmethod deserialize :uint8 [_ ^ByteBuffer stream]
  (long (bit-and 0x00ff (.get stream))))

(defmethod serialize :uint16 [_ ^ByteBuffer stream ^long obj]
  (.putShort stream (short (bit-and 0x0000ffff obj))))
(defmethod deserialize :uint16 [_ ^ByteBuffer stream]
  (long (bit-and 0x0000ffff (.getShort stream))))

(defmethod serialize :uint32 [_ ^ByteBuffer stream ^long obj]
  (.putInt stream (int (bit-and 0x00000000ffffffff obj))))
(defmethod deserialize :uint32 [_ ^ByteBuffer stream]
  (long (bit-and 0x00000000ffffffff (.getInt stream))))

;; TODO(jlowens) handle 64-bit unsigned correctly - i.e. check for bitlength
(defmethod serialize :uint64 [_ ^ByteBuffer stream obj]
  (.putLong stream (long obj)))
(defmethod deserialize :uint64 [_ ^ByteBuffer stream]
  (long (.getLong stream)))

;; handle floating values
(defmethod serialize :float32 [_ ^ByteBuffer stream ^double obj]
  (.putFloat stream (float obj)))
(defmethod deserialize :float32 [_ ^ByteBuffer stream]
  (.getFloat stream))

(defmethod serialize :float64 [_ ^ByteBuffer stream ^double obj]
  (.putDouble stream (double obj)))
(defmethod deserialize :float64 [_ ^ByteBuffer stream]
  (.getDouble stream))

;; handle string
(defmethod serialize :string [_ ^ByteBuffer stream ^String obj]
  (serialize :uint32 stream (count obj))
  (.put stream ^bytes (.getBytes obj "UTF-8")))

;; handle time
(defmethod serialize :time [_ ^ByteBuffer stream ^Time obj]
  (serialize :uint32 stream (.secs obj))
  (serialize :uint32 stream (.nsecs obj)))
(defmethod deserialize :time [_ ^ByteBuffer stream]
  (t/->Time (deserialize :uint32 stream)
            (deserialize :uint32 stream)))

;; handle duration
(defmethod serialize :duration [_ ^ByteBuffer stream ^Duration obj]
  (serialize :int32 stream (.secs obj))
  (serialize :int32 stream (.nsecs obj)))
(defmethod deserialize :time [_ ^ByteBuffer stream]
  (t/->Duration (deserialize :int32 stream)
                (deserialize :int32 stream)))


(defmethod serialize :default [_ _ obj]
  (throw (UnsupportedOperationException.
           (str "Unknown type for serialization: " (type obj)))))
(defmethod deserialize :default [_ _]
  (throw (UnsupportedOperationException.
           (str "Unknown type for deserialization"))))