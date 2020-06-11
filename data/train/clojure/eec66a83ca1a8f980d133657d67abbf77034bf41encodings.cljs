(ns cramble.encodings
  (:require [cramble.bin :refer (read-itf8 read-byte read-array)]
            [cramble.bits :refer (read-bits)]))

(defn- huffcode [alphabet lengths]
  (loop [[[len val] & rest] (sort (map vector lengths alphabet))
         cur-len len
         cur-code 0
         code {}]
    (let [cur-code (if (> len cur-len)
                     (bit-shift-left cur-code (- len cur-len))
                     cur-code)]
      (if len
        (do
          #_(println len "_" cur-code " -> " val)
          (recur rest len (inc cur-code) (assoc code (bit-or cur-code (bit-shift-left len 24)) val)))
        code))))

(defn- huffdecode [code shortest-code bs _]
  (loop [len  shortest-code
         k    (if-not (zero? shortest-code) (read-bits bs shortest-code) 0)]
    (or (code (bit-or k (bit-shift-left len 24)))
        (recur (inc len)
               (bit-or 
                (bit-shift-left k 1)
                (read-bits bs 1))))))

; 0 null
; 1 external
; 2 golomb
; 3 huffman_int
; 4 byte_array_len
; 5 byte_array_stop
; 6 beta
; 7 subexp
; 8 golomb_rice
; 9 gamma

(defmulti read-int-encoding* (fn [e stream] e))

(defmethod read-int-encoding* 0 [_ stream]
  nil)

(defmethod read-int-encoding* 1 [_ stream]
  (let [blk (read-itf8 stream)]
    (fn [_ external]
      (read-itf8 (external blk)))))

(defmethod read-int-encoding* 3 [_ stream]
  (let [alphabet (read-array read-itf8 stream)
        lengths  (read-array read-itf8 stream)]
    (partial huffdecode (huffcode alphabet lengths) (reduce min lengths))))

(defmethod read-int-encoding* 6 [_ stream]
  (let [offset (read-itf8 stream)
        length (read-itf8 stream)]
    (fn [bs _]
      (+ offset (read-bits bs length)))))

(defmethod read-int-encoding* 9 [_ stream]
  (let [offset (read-itf8 stream)]
    (fn [bs _]
      (let [cnt (loop [bits 0]
                  (if (zero? (read-bits bs 1))
                    (recur (inc bits))
                    bits))]
        (+ offset
           (bit-or (bit-shift-left 1 cnt)
                   (if (zero? cnt) 0 (read-bits bs cnt))))))))

(defmethod read-int-encoding* :default [e stream]
  (throw (js/Error. (str "Unknown int encoding " e))))
  

(defn read-int-encoding [stream]
  (let [e         (read-byte stream)
        param-len (read-itf8 stream)]
    (read-int-encoding* e stream)))

(defmulti read-byte-encoding* (fn [e stream] e))

(defmethod read-byte-encoding* 0 [_ stream]
  nil)

(defmethod read-byte-encoding* 1 [_ stream]
  (let [blk (read-itf8 stream)]
    (fn [_ external]
      (let [eb (external blk)]
        (if-not eb
          (println "Couldn't find " blk " in " external))
        (read-byte (external blk))))))

(defmethod read-byte-encoding* 3 [_ stream]
  (let [alphabet (read-array read-byte stream)
        lengths  (read-array read-itf8 stream)]
    (partial huffdecode (huffcode alphabet lengths) (reduce min lengths))))

(defmethod read-byte-encoding* :default [e stream]
  (throw (js/Error. (str "Unknown byte encoding " e))))

(defn read-byte-encoding [stream]
  (let [e         (read-byte stream)
        param-len (read-itf8 stream)]
    (read-byte-encoding* e stream)))

(defmulti read-byte-array-encoding* (fn [e stream] e))

(defmethod read-byte-array-encoding* 4 [_ stream]
  (let [lengths-encoding (read-int-encoding stream)
        values-encoding  (read-byte-encoding stream)]
    (fn [bs external]
      (loop [len (lengths-encoding bs)
             arr #js []]
        (if (> len 0)
          (do
            (.push arr (values-encoding bs external))
            (recur (dec len) arr))
          arr)))))

(defmethod read-byte-array-encoding* 5 [_ stream]
  (let [stop-byte (read-byte stream)
        external-id (read-itf8 stream)]
    (fn [bs external]
      (let [external (external external-id)]
        (loop [d #js []]
          (let [b (read-byte external)]
            (if (or (nil? b)
                    (= b stop-byte))
              d
              (do
                (.push d b)
                (recur d)))))))))

(defmethod read-byte-array-encoding* :default [e stream]
  (throw (js/Error. (str "Unknown byte array encoding " e))))

(defn read-byte-array-encoding [stream]
  (let [e          (read-byte stream)
        param-len  (read-itf8 stream)]
    (read-byte-array-encoding* e stream)))
