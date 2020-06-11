(ns hackandprotect.core
  (:require [hackandprotect.utils :refer :all])
  (:require [clojure.string :as str]))

(defn add
  "Given a character and a number,
  add the number to the ascii code of the character."
  [n c]
  (char (+ n (int c))))

(defn subtract
  "Given a character and a number,
  subtract the number from the ascii code of the character."
  [n c]
  (add (- n) c))

(defn xor
  "Given a character and a number,
  xor the number with the ascii code of the character."
  [n c]
  (char (bit-xor n (int c))))

(defn encryption-step
  "Given operation, parameter, starting index, length and stream,
  execute the operation with the given parameter on the part of the stream
  from start for length chars."
  [op param start length stream]
  (let [applied-op (partial op param)
        valid-length (min length (- (count stream) start))
        applied-stream (map-in-str applied-op stream start valid-length)]
    (if (> length valid-length)
      (str/reverse (encryption-step op param 0 (- length valid-length) (str/reverse applied-stream)))
      applied-stream)))

(def op-codes
  {
   :add      add
   :subtract subtract
   :xor      xor
   })

(defn encrypt
  [vec stream]
  (:stream (reduce (fn [acc step]
                     {:stream (encryption-step ((:op-code step) op-codes)
                                               (:op-param step)
                                               (:start acc)
                                               (:length step)
                                               (:stream acc))
                      :start  (+ (:start acc) (:length step))
                      })
                   {
                    :stream stream
                    :start  0
                    } vec)))

(defn reverse-encryption-step-op
  [step]
  (let [reversed-op-codes {
                           :add      :subtract
                           :subtract :add
                           :xor      :xor
                           }]
    (assoc step :op-code (reversed-op-codes (:op-code step)))))

(defn decrypt
  [vec stream]
  (encrypt (map reverse-encryption-step-op vec) stream))