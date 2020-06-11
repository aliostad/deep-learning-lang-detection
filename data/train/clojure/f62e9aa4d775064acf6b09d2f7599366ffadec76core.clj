(ns clj.core
  (:require clojure.set)
  (:import [java.io FileInputStream InputStreamReader BufferedReader FileOutputStream OutputStreamWriter BufferedWriter InputStream OutputStream File])
  )


(= 1 2)




(#{1 2 3} 1)

; conj: any collection
(conj [1 2] 3)
(conj '(1 2) 3)
(conj #{1 2 3} 4)

; set union
(clojure.set/union #{1 2} #{3 4})


; cons: return sequence
(cons 3 '(1 2))
; equaivalent to
(cons 3 (seq '(1 2)))

; use meta data to do type-hint
(defn shout [^String msg]
  (.toUpperCase msg))

(shout "abc")


; return a sequence
(list* 1 2 3 [])
(first [1 2 3])
(rest [1 2 3])
(next [1 2 3])
(rest [1])
(next [1])


; get on collections

(get {:a 1 :b 2} :b)
(get [10 15] 1)
(get #{1 10} 1)
(get #{1 10} 0)
(get [1 2 3 4] 10)
(get [1 2 3 4] 10 "not found")



; Building data abstractions


(defn gulp [src]
  (let [sb (StringBuilder.)]
    (with-open [reader (make-reader src)]
      (loop [c (.read reader)]
          (if (neg? c)
            (str sb)
            (do
              (.append sb (char c))
              (recur (.read reader))))))))



(defn expectorate [dst content]
  (with-open [writer (make-writer dst)]
    (.write writer content)
    ))

(defprotocol IOFactory
  (make-reader [this] "Create a buffered reader")
  (make-writer [this] "Create a buffered writer"))

(extend-protocol IOFactory
  InputStream
  (make-reader [src]
               (-> src InputStreamReader. BufferedReader.))
  (make-writer [dst]
               (throw (IllegalArgumentException. "Can't open an input stream for writing")))

  OutputStream
  (make-reader [src]
               (throw (IllegalArgumentException. "Can't open an output stream for reading")))
  (make-writer [dst]
               (-> dst OutputStreamWriter. BufferedWriter.))

  File
  (make-reader [src]
               (make-reader (FileInputStream. src)))
  (make-writer [dst]
               (make-writer (FileOutputStream. dst))))


; (gulp (File. "/Users/seckcoder/Documents/pwd"))


; multimethod


; difference between doto and ->
(doto (HashMap.) (.put "a" 1) (.put "b" 2))
