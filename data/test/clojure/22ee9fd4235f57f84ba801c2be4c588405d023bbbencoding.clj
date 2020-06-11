(ns btcj.bencoding)

(def string-delimiter ":" )

(def int-begin-delimiter \i )

(def list-begin-delimiter \l )

(def dict-begin-delimiter \d )

(def common-end-delimiter "e" )

(declare bencode-commons)

(declare bdecode-stream)

(defn rest-stream [stream]
  (let [first-atom-length 
    (if (= (get stream 0) int-begin-delimiter)
       (count (apply str (re-seq #"\bi[0-9]+e" stream)))
       (+ (count (apply str(take-while #(not (= \: %)) stream)))
          (Integer. (apply str(take-while #(not (= \: %)) stream))) 1))]
    (apply str (drop first-atom-length stream))))

(defn bencode-string [input-string] 
  (str (count input-string) string-delimiter input-string))

(defn bdecode-string [encoded-string] 
  (let [descriptor-length
        (count (apply str(take-while #(not (= \: %)) encoded-string)))
        length 
        (Integer. (apply str(take-while #(not (= \: %)) encoded-string)))]
    (apply str (take length (apply str (drop (+ descriptor-length 1) encoded-string)))))
  )

(defn bencode-int [input-int] 
  (str int-begin-delimiter input-int common-end-delimiter))

(defn bdecode-int [encoded-int]
  (let [first-ocurrence (apply str (re-seq #"\bi[0-9]+e" encoded-int))]
    (Integer. (apply str (drop 1 (drop-last 1 first-ocurrence))))))

(defn bencode-list [input-list] 
  (str list-begin-delimiter (apply str (map bencode-commons input-list)) common-end-delimiter))

(defn bdecode-list [encoded-list] 
  (let [inner-elements (apply str (drop 1 (drop-last 1 encoded-list)))]
   (if (= 0 (count inner-elements))
     (vector)
     (apply vector (bdecode-stream inner-elements))))
   )

(defn bencode-commons [input]
  (cond 
    (vector? input) (bencode-list input)
    (integer? input) (bencode-int input)
    (string? input) (bencode-string input)
    )
  )

(defn bencode-dict [input-dict]
  (let [bencode-key-value (fn [x] 
                            (apply str (str (bencode-commons (key x)) (bencode-commons (val x))))) ] 
    (str dict-begin-delimiter (apply str (map bencode-key-value (sort-by first input-dict))) common-end-delimiter)))

(defn bdecode-dict [encoded-dict] 
   (let [inner-elements (drop 1 (drop-last 1 encoded-dict))]
   (if (= 0 (count inner-elements))
     (hash-map)
     (apply hash-map (bdecode-stream inner-elements))))
   )

(defn append-stream [new-item stream]
  (if (list? stream)
    (conj stream new-item)
    (list new-item stream)))

(defn bdecode-atoms [stream]
  (let [stream-rest (rest-stream stream)]
    (cond 
      (= (count stream-rest) 0) 
        (if (= (get stream 0) int-begin-delimiter)
          (bdecode-int stream)
          (bdecode-string stream))
      (= (get stream 0) int-begin-delimiter) (append-stream (bdecode-int stream) (bdecode-stream  stream-rest))
      :else (append-stream (bdecode-string stream) (bdecode-stream  stream-rest))
      )
    )
  )

(defn bdecode-stream [input] 
  (cond 
    (= (get input 0) list-begin-delimiter) (bdecode-list input)
    (= (get input 0) dict-begin-delimiter) (bdecode-dict input)
    :else (bdecode-atoms input)
    )
  )