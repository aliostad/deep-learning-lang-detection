(ns reader.min-spit
  (:import (java.io FileInputStream InputStreamReader BufferedReader)))
(defn min-spit [src]
    (let [sb (new StringBuilder)]
        (with-open [reader (-> src FileInputStream. InputStreamReader. BufferedReader.)]
            (loop [readChar (.read reader)]
                (if (neg? readChar) (str sb) 
                    (do (.append sb (char readChar))
                        (recur (.read reader))))))))


(defn make-reader [src] (-> src FileInputStream. InputStreamReader. BufferedReader.))



