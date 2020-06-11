;;; stream.clj represents a stream abstraction. At the current moment it
;;; supporting read from a file. Read from stdin and other sources is an
;;; extension I would love to implement once I'm done with mini Java compiler.
;;; Along with the stream representation it provides routines that operate
;;; on `Stream' and provide information like num of characters read.

(ns compiler.common.stream)

;;;; Should `Stream' have a c-count member/field?
;;;; char-read tells the consumer of the stream how many characters they have
;;;; consumed from the stream. It is achieved with help of a function named
;;;; `char-read ()'. I decided to maintain the number of character read in the
;;;; stream instead of doing it in the lexical analyzer or delegating it to
;;;; the users. The pros and cons of including char-read field are listed
;;;; below.
;;;; Pros:
;;;; 1. If the stream can maintain the number of character read/consumed from
;;;;    it, then calculating the length of lexeme becomes trivial and fast.
;;;; 2. Lexer/users doesn't have to maintain this, making the job of lexical
;;;;    anlaysis simple.
;;;; Cons:
;;;; 1. Concurrent reading?
;;;; 
;;;; Couldn't find any more cons, hence addition of `c-count' to `Stream'
(defrecord Stream [l c-count])


(defn file-exists? [s]
  {:pre [(not= s "")
         (false? (clojure.string/blank? s))
         (not= s "-")]}
  (try
    (.exists (clojure.java.io/file s))
    (catch Exception _ false)))


(defn make-stream [s]
  (if (file-exists? s)
    ;; TODO: Change this implementation of stream, it is very inefficient
    ;; to use lists for mimicking streams.
    (Stream. (seq (slurp s)) 0)
    (do
      (print "Error! could not open file %s for reading" s)
      false)))


(defn peek-char [stream] 
  {:pre [(instance? Stream stream)]}
  (first (:l stream)))

(peek-char (Stream. (seq "x = 10;") 0))

(defn empty-stream? [stream]
  {:pre [(instance? Stream stream)]}
  (empty? (:l stream)))


(defn get-char [{l :l c-count :c-count :as stream}]
  {:pre [(or (zero? c-count) (pos? c-count))]}
  (if (empty-stream? stream)
    false
    [(first l) (Stream. (rest l) (inc c-count))]))
    ;; TODO: Find out why the following code is not working.
    ;; (-> (inc c-count) (Stream. (rest l)) [(first l)])))


(defn char-count [{l :l c-count :c-count :as stream}]
  {:pre [(instance? Stream stream)
         (or (zero? c-count) (pos? c-count))]}
  c-count)


(defn advance [n {l :l c-count :c-count :as stream}]
  {:pre [(or (zero? c-count) (pos? c-count))]}
  (cond
    (empty-stream? stream) false
    (< n 1) stream
    :else (advance (dec n) (Stream. (rest l) (inc c-count))))) 
    ;; TODO: Find out why the following code is not working.
    ;; (-> (inc c-count) (Stream. (rest l)) (advance (dec n)))))


(defn advance-1 [stream] (advance 1 stream))
