(ns csi.etf.encode
  (:require [csi.etf.decode :as decode]
    [clojure.set :as set]))

(def tags
  (set/map-invert decode/tags))

(defn make-stream [size]
  (let [buffer (js/ArrayBuffer. size)]
    { :buffer buffer
      :dv (js/DataView. buffer)
      :pos 0}))

(defn get-buffer [{:keys [buffer pos]}]
  (.slice buffer 0 pos))

(defn seek-relative [stream offset]
  (update-in stream [:pos] + offset))

(defn ensure-storage [{:keys [buffer pos] :as stream} datum-size]
  (let [size (.-byteLength buffer)
        avail (- size pos)]
    (if (> avail datum-size)
      stream
      (let [stream' (make-stream (* 2 size))
            buffer' (stream' :buffer)]
        (.set (js/Uint8Array. buffer') (js/Uint8Array. buffer))
        (assoc stream' :pos pos)))))

(defn write-datum [stream js-method value-size value]
  (let [{:keys [dv pos] :as stream'} (ensure-storage stream value-size)]
    (js-invoke dv js-method pos value)
    (seek-relative stream' value-size)))

(defn write-uint8 [stream value]
  (write-datum stream "setUint8" 1 value))

(defn write-uint16 [stream value]
  (write-datum stream "setUint16" 2 value))

(defn write-uint32 [stream value]
  (write-datum stream "setUint32" 4 value))

(defn write-int32 [stream value]
  (write-datum stream "setInt32" 4 value))

(defn write-float64 [stream value]
  (write-datum stream "setFloat64" 8 value))

;encoders

(defn encode-small-integer [stream si]
  (-> stream
    (write-uint8 (tags :small-integer))
    (write-uint8 si)))

(defn encode-integer [stream value]
  (-> stream
    (write-uint8 (tags :integer))
    (write-int32 value)))

(defn encode-float [stream value]
  (-> stream
    (write-uint8 (tags :new-float))
    (write-float64 value)))

(defn encode-nil [stream]
  (write-uint8 stream (tags :nil)))

(declare encode-term)

(defn encode-counted [stream vector & {:keys [tag count-writer-fn]}]
  (reduce
    (fn [stream item]
      (encode-term stream item))

    (-> stream
      (write-uint8 (tags tag))
      (count-writer-fn (count vector)))
    vector))

(defn encode-keyword [stream keyword]
  (let [name (name keyword)]
    (reduce
      (fn [stream pos]
        (write-uint8 stream (.charCodeAt name pos)))

      (-> stream
        (write-uint8 (tags :atom))
        (write-uint16 (count name)))

      (range (count name)))))

(defn encode-array-buffer [stream buffer]
  (let [length (.-byteLength buffer)]
    (reduce
      (fn [stream pos]
        (write-uint8 stream (aget buffer pos)))

      (-> stream
        (write-uint8 (tags :binary))
        (write-uint32 length))

      (range length))))

(defn encode-pid [stream {:keys [node id serial creation]}]
  (-> stream
    (write-uint8 (tags :pid))
    (encode-term node)
    (write-uint32 id)
    (write-uint32 serial)
    (write-uint8 creation)))

(defn encode-term [stream term]
  (cond
    (and (integer? term) (>= term 0) (< term 255))
      (encode-small-integer stream term)

    (integer? term)
      (encode-integer stream term)

    (number? term)
      (encode-float stream term)

    (keyword? term)
      (encode-keyword stream term)

    (instance? js/Uint8Array term)
      (encode-array-buffer stream term)

    (instance? decode/Pid term)
      (encode-pid stream term)

    (and (list? term) (empty? term))
      (encode-nil stream)

    (and (vector? term) (< (count term) 255))
      (encode-counted stream term :tag :small-tuple :count-writer-fn write-uint8)

    (and (vector? term))
      (encode-counted stream term :tag :large-tuple :count-writer-fn write-uint32)

    (list? term)
      (write-uint8
        (encode-counted stream term :tag :list :count-writer-fn write-uint32) (tags :nil))

    (map? term)
      (encode-counted stream
        (apply concat (into [] term)) :tag :map
          :count-writer-fn (fn [stream _] (write-uint32 stream (count term))))

    :else
      (throw (str "don't know how to encode: " (str term)))))

(def initial-stream-size 1024)

(defn encode* [term]
  (-> (make-stream initial-stream-size)
    (write-uint8 (tags :term))
    (encode-term term)
    get-buffer))
