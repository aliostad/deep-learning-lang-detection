(ns cassius.test-streaming
  (:use midje.sweet)
  (:require [cassius.core :refer :all]
            [cassius.net.command.retrieve :as retrieve]
            [cassius.net.command.stream :as stream]))

(def settings
  (read-string (slurp "settings.edn")))

(def conn (connect (:host settings)
                   (:port settings)
                   {:type :connection
                    :value-type :utf-8}))

(fact
  "Populate 1000 supercolumn samples"

  (dotimes [i 1000]
    (put-in conn ["sample" "super" (str i) "data"] {"value" (str i)}))

  "Check that there are 1000 samples"

  (-> (peek-in conn ["sample" "super"])
      count)
  => 1000)


(fact
  "Populate 1000 standard column samples"
  (dotimes [i 1000]
    (put-in conn ["sample" "standard" (str i) "data"] (str i)))

  "Check that there are 1000 samples"
  (-> (peek-in conn ["sample" "standard"])
      count)
  => 1000)

(fact
  "Populate a Supercolumn with 1000 columns"
  (dotimes [i 1000]
    (put-in conn ["sample" "data" "data" (str i)] {"value" (str i)}))

  "Check that there are 1000 samples"
  (-> (peek-in conn ["sample" "data" "data"])
      count)
  => 1000)

(defmacro time-total
  "Evaluates expr and prints the time it took.  Returns the value of
 expr."
  {:added "1.0"}
  [n expr]
  `(apply + (for [i# (range ~n)]
              (let [start# (. System (nanoTime))
                    ret# ~expr]
                (/ (double (- (. System (nanoTime)) start#)) 1000000.0)))))

(println "CF: Streams in the same block (80, 90) around 0.8 < R < 1.2"
     (/ (time-total 100 (nth (stream/stream-column-family conn "sample" "super") 80))
        (time-total 100 (nth (stream/stream-column-family conn "sample" "super") 99))))

(println "CF: Streams in the same block (100, 90) around R > 1.5"
     (/ (time-total 100 (nth (stream/stream-column-family conn "sample" "super") 100))
        (time-total 100 (nth (stream/stream-column-family conn "sample" "super") 99))))

(println "CF: Streams in the same block (999, 90) around R > 1.5"
     (/ (time-total 100 (nth (stream/stream-column-family conn "sample" "super") 999))
        (time-total 100 (nth (stream/stream-column-family conn "sample" "super") 99))))

(println "ROW: Streams in the same block (80, 90) around  0.8 < R < 1.2"
    (/ (time-total 100 (nth (stream/stream-row conn "sample" "data" "data") 80))
       (time-total 100 (nth (stream/stream-row conn "sample" "data" "data") 99))))

(println "ROW: Streams in a different block (100, 90) around R > 1.5"
    (/ (time-total 100 (nth (stream/stream-row conn "sample" "data" "data") 100))
       (time-total 100 (nth (stream/stream-row conn "sample" "data" "data") 99))))

(println "ROW: Streams in a larger block (999, 90) around R > 9"
   (/ (time-total 100 (nth (stream/stream-row conn "sample" "data" "data") 999))
      (time-total 100 (nth (stream/stream-row conn "sample" "data" "data") 99))))