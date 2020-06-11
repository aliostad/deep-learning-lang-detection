(ns deep-freeze.core
  [:import java.io.DataInputStream java.io.DataOutputStream])

;;;; TODO
;; * Possible to de/serialize types, records, functions?
;; * Investigate performance effect of memoizing serialization when possible
;;   (esp. keywords).
;; * Investigate performance and compression effect of interning keywords.
;; * Support Snappy stream compression? Would require some significant changes
;;   to code including lots of duplication for compression-on/compression-off
;;   cases. (Unless Snappy stream could be "switched off" and could be told to
;;   just pass input through unchanged?). Is there much demand for this feature?

(def ^:const ^Byte INTEGER   0)
(def ^:const ^Byte LONG      1)
(def ^:const ^Byte FLOAT     2)
(def ^:const ^Byte DOUBLE    3)
(def ^:const ^Byte BIGINT    4)
(def ^:const ^Byte BIGDEC    5)
(def ^:const ^Byte RATIO     6)
(def ^:const ^Byte BOOLEAN   7)
(def ^:const ^Byte CHAR      8)
(def ^:const ^Byte STRING    9)
(def ^:const ^Byte KEYWORD   10)
(def ^:const ^Byte LIST      11)
(def ^:const ^Byte VECTOR    12)
(def ^:const ^Byte SET       13)
(def ^:const ^Byte MAP       14)
(def ^:const ^Byte COLL      15)
(def ^:const ^Byte ATOM      16)
(def ^:const ^Byte REF       17)
(def ^:const ^Byte AGENT     18)
(def ^:const ^Byte META      19)
(def ^:const ^Byte NIL       20)
(def ^:const ^Byte BYTEARRAY 21)

;;;;; TODO Still to implement support for these
;;(def ^:const ^Byte TYPE      22) ; clojure.lang.IType
;;(def ^:const ^Byte RECORD    23) ; clojure.lang.IRecord
;;(def ^:const ^Byte FN        24) ; clojure.lang.IFn

(declare freeze-to-stream!)
(declare thaw-from-stream!)

(defn- write-type! [^DataOutputStream stream ^Byte type] (.writeByte stream type))

(defn- write-ByteArray!
  "Write arbitrary ByteArray to stream, prepended by its length."
  [^DataOutputStream stream ^bytes ba]
  (let [len (alength ba)]
    (.writeShort stream len) ; Encode length
    (.write stream ba 0 len)))

(defn- read-ByteArray!
  "Read arbitrary ByteArray from stream, prepended by its length."
  ^bytes [^DataInputStream stream]
  (let [len (.readShort stream)
        ba  (byte-array len)]
    (.read stream ba 0 len)
    ba))

(defn- write-as-ByteArray!
  "Write arbitrary object to stream as ByteArray, prepended by its length."
  [^DataOutputStream stream obj]
  (write-ByteArray! stream (.toByteArray obj)))

(defn- read-BigInteger!
  "Wrapper around read-ByteArray! for common case of reading to a BigInteger.
  Note that as of Clojure 1.3, Clojure's BigInt ≠ Java's BigInteger."
  ^java.math.BigInteger [^DataInputStream stream]
  (java.math.BigInteger. (read-ByteArray! stream)))

(defprotocol Freezeable (freeze [obj ^DataOutputStream stream]))

;; Arbitrary ByteArray, needs to be defined outside of extend-protocol
(extend-type (Class/forName "[B")
  Freezeable
  (freeze [itm ^DataOutputStream stream]
    (write-type! stream BYTEARRAY)
    (write-ByteArray! stream itm)))

(extend-protocol Freezeable
  java.lang.Integer
  (freeze [itm ^DataOutputStream stream]
    (write-type! stream INTEGER)
    (.writeInt stream itm))
  java.lang.Long
  (freeze [itm ^DataOutputStream stream]
    (write-type! stream LONG)
    (.writeLong stream itm))
  java.lang.Float
  (freeze [itm ^DataOutputStream stream]
    (write-type! stream FLOAT)
    (.writeFloat stream itm))
  java.lang.Double
  (freeze [itm ^DataOutputStream stream]
    (write-type! stream DOUBLE)
    (.writeDouble stream itm))
  clojure.lang.BigInt ; Native in Clojure >= 1.3.0
  (freeze [itm ^DataOutputStream stream]
    (write-type! stream BIGINT)
    (write-as-ByteArray! stream (.toBigInteger itm)))
  java.math.BigInteger ; Native in Clojure <= 1.2.0
  (freeze [itm ^DataOutputStream stream]
    (write-type! stream BIGINT)
    (write-as-ByteArray! stream itm))
  java.math.BigDecimal
  (freeze [itm ^DataOutputStream stream]
    (write-type! stream BIGDEC)
    (write-as-ByteArray! stream (.unscaledValue itm))
    (.writeInt stream (.scale itm)))
  clojure.lang.Ratio
  (freeze [itm ^DataOutputStream stream]
    (write-type! stream RATIO)
    (write-as-ByteArray! stream (.numerator   itm))
    (write-as-ByteArray! stream (.denominator itm)))
  java.lang.Boolean
  (freeze [itm ^DataOutputStream stream]
    (write-type! stream BOOLEAN)
    (.writeBoolean stream itm))
  java.lang.Character
  (freeze [itm ^DataOutputStream stream]
    (write-type! stream CHAR)
    (.writeChar stream (int itm)))
  java.lang.String
  (freeze [itm ^DataOutputStream stream]
    (write-type! stream STRING)
    (.writeUTF stream itm))
  clojure.lang.Keyword
  (freeze [itm ^DataOutputStream stream]
    (write-type! stream KEYWORD)
    (.writeUTF stream (name itm)))
  clojure.lang.IPersistentList
  (freeze [itm ^DataOutputStream stream]
    (write-type! stream LIST)
    (.writeInt stream (count itm)) ; Encode length
    (doseq [i itm] (freeze-to-stream! i stream)))
  clojure.lang.IPersistentVector
  (freeze [itm ^DataOutputStream stream]
    (write-type! stream VECTOR)
    (.writeInt stream (count itm)) ; Encode length
    (doseq [i itm] (freeze-to-stream! i stream)))
  clojure.lang.IPersistentSet
  (freeze [itm ^DataOutputStream stream]
    (write-type! stream SET)
    (.writeInt stream (count itm)) ; Encode length
    (doseq [i itm] (freeze-to-stream! i stream)))
  clojure.lang.IPersistentMap
  (freeze [itm ^DataOutputStream stream]
    (write-type! stream MAP)
    (.writeInt stream (count itm)) ; Encode length
    (doseq [i itm]
      (freeze-to-stream! (first i) stream)
      (freeze-to-stream! (second i) stream)))
  clojure.lang.IPersistentCollection ; Non-specific collection
  (freeze [itm ^DataOutputStream stream]
    (write-type! stream COLL)
    (.writeInt stream (count itm)) ; Encode length
    (doseq [i itm] (freeze-to-stream! i stream)))
  clojure.lang.Atom
  (freeze [itm ^DataOutputStream stream]
    (write-type! stream ATOM)
    (freeze-to-stream! @itm stream))
  clojure.lang.Ref
  (freeze [itm ^DataOutputStream stream]
    (write-type! stream REF)
    (freeze-to-stream! @itm stream))
  clojure.lang.Agent
  (freeze [itm ^DataOutputStream stream]
    (write-type! stream AGENT)
    (freeze-to-stream! @itm stream))
  nil
  (freeze [itm ^DataOutputStream stream]
    (write-type! stream NIL))
  Object
  (freeze [itm ^DataOutputStream stream]
    (throw (java.lang.Exception.
            (str "Don't know how to freeze " (class itm) ". "
                 "Consider extending Freezeable?")))))

(defn freeze-to-stream! [item ^DataOutputStream stream]
  (if-let [m (meta item)]
    (do (write-type! stream META)
        (freeze-to-stream! m stream)))
  (freeze item stream))

(defn freeze-to-array
  ([item] (freeze-to-array item true))
  ([item compress?]
     (let [ba (java.io.ByteArrayOutputStream.)
           stream (DataOutputStream. ba)]
       (freeze-to-stream! item stream)
       (.flush stream)
       (if compress?
         (org.xerial.snappy.Snappy/compress (.toByteArray ba))
         (.toByteArray ba)))))

(defmulti thaw (fn [^Byte type ^DataInputStream stream] type))

(defmethod thaw BYTEARRAY
  [_ ^DataInputStream stream]
  (read-ByteArray! stream))
(defmethod thaw INTEGER
  [_ ^DataInputStream stream]
  (.readInt stream))
(defmethod thaw LONG
  [_ ^DataInputStream stream]
  (.readLong stream))
(defmethod thaw FLOAT
  [_ ^DataInputStream stream]
  (.readFloat stream))
(defmethod thaw DOUBLE
  [_ ^DataInputStream stream]
  (.readDouble stream))
(defmethod thaw BIGINT
  [_ ^DataInputStream stream]
  (bigint (read-BigInteger! stream)))
(defmethod thaw BIGDEC
  [_ ^DataInputStream stream]
  (java.math.BigDecimal. (read-BigInteger! stream) (.readInt stream)))
(defmethod thaw RATIO
  [_ ^DataInputStream stream]
  (/ (bigint (read-BigInteger! stream)) (bigint (read-BigInteger! stream))))
(defmethod thaw BOOLEAN
  [_ ^DataInputStream stream]
  (.readBoolean stream))
(defmethod thaw CHAR
  [_ ^DataInputStream stream]
  (.readChar stream))
(defmethod thaw STRING
  [_ ^DataInputStream stream]
  (.readUTF stream))
(defmethod thaw KEYWORD
  [_ ^DataInputStream stream]
  (keyword (.readUTF stream)))
(defmethod thaw LIST
  [_ ^DataInputStream stream]
  (let [len (.readInt stream)]
    (apply list (repeatedly len (fn [] (thaw-from-stream! stream))))))
(defmethod thaw VECTOR
  [_ ^DataInputStream stream]
  (let [len (.readInt stream)]
    (vec (repeatedly len (fn [] (thaw-from-stream! stream))))))
(defmethod thaw SET
  [_ ^DataInputStream stream]
  (let [len (.readInt stream)]
    (set (repeatedly len (fn [] (thaw-from-stream! stream))))))
(defmethod thaw MAP
  [_ ^DataInputStream stream]
  (let [len (.readInt stream)]
    (persistent!
     (reduce (fn [m _]
               (assoc! m (thaw-from-stream! stream) (thaw-from-stream! stream)))
             (transient {}) (range len)))))
(defmethod thaw COLL
  [_ ^DataInputStream stream]
  (let [len (.readInt stream)]
    (repeatedly len (fn [] (thaw-from-stream! stream)))))
(defmethod thaw ATOM
  [_ ^DataInputStream stream]
  (atom (thaw-from-stream! stream)))
(defmethod thaw REF
  [_ ^DataInputStream stream]
  (ref (thaw-from-stream! stream)))
(defmethod thaw AGENT
  [_ ^DataInputStream stream]
  (agent (thaw-from-stream! stream)))
(defmethod thaw META
  [_ ^DataInputStream stream]
  (let [m (thaw-from-stream! stream)]
    (with-meta (thaw-from-stream! stream) m)))
(defmethod thaw NIL
  [_ ^DataInputStream stream]
  nil)

(defn thaw-from-stream!
  [^DataInputStream stream]
  (thaw (.readByte stream) ; Type
        stream))

(defn thaw-from-array
  ([array] (thaw-from-array array true))
  ([array compressed?]
     (thaw-from-stream!
      (DataInputStream.
       (java.io.ByteArrayInputStream.
        (if compressed?
          (org.xerial.snappy.Snappy/uncompress array)
          array))))))

;;;; Benchmarking
(comment
  (defn- array-roundtrip [item compress?]
    (thaw-from-array (freeze-to-array item compress?) compress?))

  (def stressrec
   {:longs   (range 1000)
    :doubles (repeatedly 1000 rand)
    :strings (repeat 1000 "This is a UTF8 string! ಬಾ ಇಲ್ಲಿ ಸಂಭವಿಸ")})

  (def pre-frozen-compressed   (freeze-to-array stressrec true))
  (def pre-frozen-uncompressed (freeze-to-array stressrec false))

  (time (dotimes [_ 1000] (array-roundtrip stressrec false)))

  ;;; Intel Core i7 2.67Ghz notebook, 1Gb memory virtual machine
  ;;; Roundtrips

  ;; clj-serializer 0.1.3 wo/comp: 5200ms
  ;; ------------------------------------
  ;; deep-freeze    1.0.0 wo/comp: 7300ms
  ;;                1.1.0 wo/comp: 3700ms
  ;;                1.2.0 wo/comp: 3700ms
  ;;                       w/comp: 4800ms
  ;;                1.2.2 wo/comp: 3500ms
  ;;                       w/comp: 4100ms

  ;;; Deserialization only (1.2.2)
  (time (dotimes [_ 10000] (thaw-from-array pre-frozen-compressed true)))    ; 1900ms
  (time (dotimes [_ 10000] (thaw-from-array pre-frozen-uncompressed false))) ; 140ms

  ;;; Compression (1.2.2)
  (count (String. (freeze-to-array stressrec false))) ; 58,538 chars
  (count (String. (freeze-to-array stressrec true)))  ; 16,842 chars
  ;; i.e. a 29% ratio in string format

  ;;(remove-ns 'deep-freeze.core)
  ;;(remove-ns 'deep-freeze.test.core)
  )


;;;; Experimental/dev (streaming compression)
(comment

  (with-open
      [f (org.xerial.snappy.SnappyOutputStream.
          (java.io.DataOutputStream.
           (java.io.FileOutputStream. "foo.bin")))]
    (.write f 33))

  (with-open
      [f (org.xerial.snappy.SnappyInputStream.
          (java.io.DataInputStream.
           (java.io.FileInputStream. "foo.bin")))]
    (.read f))

  ;; Seems we'd need to change every use of DataOutputStream?
  ;; And how does the streamed compression ratio compare to all-at-once
  ;; compression? Presumably it'd be less effective, yes?

  )