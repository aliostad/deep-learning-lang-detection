(ns geometry_msgs
  (:require [rosclj.msg :as m]
            [rosclj.serialization :as s])
  (:import (java.nio ByteBuffer)))


;; Message definition for Vector3
(def spec-Vector3 [])
(defrecord Vector3 [_spec x y z]
  m/IMessage
  (is-fixed-size? [this] true)
  (byte-count [this] 24)
  (to-stream [_ stream]
    (s/serialize :float64 stream x)
    (s/serialize :float64 stream y)
    (s/serialize :float64 stream z))
  (from-stream [_ stream]
    (let [_x (s/deserialize :float64 stream)
          _y (s/deserialize :float64 stream)
          _z (s/deserialize :float64 stream)]
      (->Vector3 _spec _x _y _z))))
(defn create-Vector3
  ([] (->Vector3 spec-Vector3 0 0 0))
  ([m] (map->Vector3 (assoc m :_spec spec-Vector3)))
  ([x y z] (->Vector3 spec-Vector3 x y z)))