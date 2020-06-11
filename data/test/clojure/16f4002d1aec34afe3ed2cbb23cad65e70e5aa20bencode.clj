(ns bencode)

;; (defn decode [s]
;;   (loop [[c & stream] (seq s) parsed nil]
;;     (if c
;;       (cond (= c \i) (let [[ss num] (parseInt stream)]
;;                        (recur 
;;             :else (error)
;;             )
;;       (error))))

(defn- error []
  (throw 
   (IllegalArgumentException. 
    "Can not parse input string")))


(defn- isDigit [c]
  (<= 48 (int c) 57))

(defn- parseInt [stream]
  "Return remaining stream or integer from stream"
  (let [minus (= \- (first stream))
        stream* (if minus (rest stream) stream)
        [[c & cs] num] 
        (->> stream*
             (take-while isDigit)
             (apply str)
             (#(if-not (empty? %)(bigint %) (error)))
             (list (drop-while isDigit stream*)))]
    (if (= c \e) [cs (* num (if minus -1 1))] (error))))
