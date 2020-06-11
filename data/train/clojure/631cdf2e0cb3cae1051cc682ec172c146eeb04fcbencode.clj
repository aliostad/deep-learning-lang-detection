(ns bitjorrent.bencode
  (:require [clojure.java.io :as io])
  (:gen-class))

(def filename "/Users/ben/workspace/bitjorrent/test/test.torrent")

; could be recursive
(defn parse-list
  [])

(defn parse-int
  ([stream] ;; this arity is for returning just the number without a struct
   (loop [[n & more] stream
          acc ""]
     (if (and (not (= n \e)) (not (= n \:)))
       (recur more (str acc n))
       (do
;;         (println "parse int:" acc) ;; to be removed, only for debugging
         [more (read-string acc)]))))
  ([stream struct] ;; this arity is for returning the number included in the provided struct
   (let [[tmp_stream num] (parse-int stream)]
     [tmp_stream (conj struct num)])))

;; not recursive
(defn parse-bytes
  ([stream]
   (let [[tmp_stream num] (parse-int stream)]
     (loop [newstream tmp_stream
            i (dec num) ;; dec to get rid of colon
            acc ""]
       (if (> i 0)
         (recur (rest newstream) (dec i) (str acc (first newstream)))
         (let [result (str acc (first newstream))]
;;           (println "parse bytes:" result) ;; to be removed, only for debugging
           [(rest newstream) result])))))
  ([stream struct]
   (let [[tmp_stream bytes] (parse-bytes stream)]
     [tmp_stream (conj struct bytes)])))

(declare parse-token)

(defn parse-pair
  ([stream]
   (let [[new_stream key] (parse-token stream)
         [newer_stream value] (parse-token new_stream)]
;;     (println "key:" key)
;;     (println "value:" value)
     [newer_stream [key value]])))

(defn parse-dict
  ([stream]
   (loop [[tmp_stream kv_pair] (parse-pair stream) 
          acc {}]
     (let [new_acc (conj acc kv_pair)]
       (if (not (= (first tmp_stream) \e))
         (recur (parse-pair tmp_stream) new_acc)
         [(rest tmp_stream) new_acc]))))
  ([stream struct]
   (let [[new_stream new_struct] (parse-dict stream)]
     [new_stream (conj struct new_struct)])))

(defn parse-token
  ([stream]
   (let [[first_char & more] stream]
     (cond
       (= first_char \d) (parse-dict more)
       (= first_char \i) (parse-int more)
       (re-matches #"\d" (str first_char)) (parse-bytes stream)
       :else (println "This is bad, should not be here"))))
  ([stream struct]
   (let [[tmp_stream token] (parse-token stream)]
     [tmp_stream (conj struct token)])))

(defn parse-tokens
  ([stream]
   (parse-tokens stream ()))
  ([stream struct]
   (let [[new_stream new_struct] (parse-token stream struct)]
     (if (not (empty? new_stream))
       (recur new_stream new_struct)
       new_struct))))

(defn file-stream
  [uri]
  (let [in (io/input-stream uri)]
    (letfn [(f [ins]
              (lazy-seq
               (let [byte (.read ins)]
                 (when (not= byte -1)
                   (cons byte (f ins))))))]
      (f in))))

(defn decode
  [path]
  (let [char-stream (map char (file-stream path))
        results (parse-tokens char-stream)]
    (println "results:" results)
    results))

