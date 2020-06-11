(ns cramble.bin)

(defprotocol IBinaryStream
  (read-byte  [this])
  (read-short [this])
  (read-int   [this])
  (read-float [this])
  (tell       [this])
  (skip-bytes [this cnt]))

(def temp-ba (js/Uint8Array. 8))
(def temp-buf (.-buffer temp-ba))
(def temp-fa (js/Float32Array. temp-buf))

(deftype ByteBufferStream [ba ^:mutable pos]
  IBinaryStream
  (read-byte [_]
    (let [p pos]
      (set! pos (+ p 1))
      (aget ba p)))

  (read-short [_]
    (let [p pos]
      (set! pos (+ p 2))
      (bit-or
       (bit-shift-left (aget ba (+ p 1)) 8)
       (aget ba p))))

  (read-int [_]
    (let [p pos]
      (set! pos (+ p 4))
      (bit-or
       (bit-shift-left (aget ba (+ p 3)) 24)
       (bit-shift-left (aget ba (+ p 2)) 16)
       (bit-shift-left (aget ba (+ p 1)) 8)
                       (aget ba p))))

  (read-float [_]
    (doseq [x (range 4)]
      (aset temp-ba x (aget ba (+ pos x))))
    (set! pos (+ pos 4))
    (aget temp-fa 0))

  (tell [_] pos)
  
  (skip-bytes [_ cnt]
    (set! pos (+ pos cnt))))
  
(defn make-binary-stream 
  ([buffer]
   (make-binary-stream buffer 0))
  ([buffer offset]  
   (ByteBufferStream. (js/Uint8Array. buffer) offset)))

(defn read-itf8 
  "Read an ITF8-encoded integer (between 1 and 5 bytes) from `stream`."
  [stream]
  (let [b0 (read-byte stream)]
    (cond
     (= (bit-and b0 0x80) 0)
     b0
     
     (= (bit-and b0 0x40) 0)
     (bit-or
      (bit-shift-left (bit-and b0 0x7f) 8)
      (read-byte stream))

     (= (bit-and b0 0x20) 0)
     (bit-or
      (bit-shift-left (bit-and b0 0x3f) 16)
      (bit-shift-left (read-byte stream) 8)
      (read-byte stream))

     (= (bit-and b0 0x10) 0)
     (bit-or
      (bit-shift-left (bit-and b0 0x1f) 24)
      (bit-shift-left (read-byte stream) 16)
      (bit-shift-left (read-byte stream) 8)
      (read-byte stream))

     :default
     (bit-or
      (bit-shift-left (bit-and b0 0xf) 28)
      (bit-shift-left (read-byte stream) 20)
      (bit-shift-left (read-byte stream) 12)
      (bit-shift-left (read-byte stream) 4)
      (bit-and 0xf (read-byte stream))))))

(defn read-array [type stream]
  (let [cnt (read-itf8 stream)]
    (vec
     (for [i (range cnt)]
       (type stream)))))

(defn read-bool [stream]
  (not= (read-byte stream) 0))
