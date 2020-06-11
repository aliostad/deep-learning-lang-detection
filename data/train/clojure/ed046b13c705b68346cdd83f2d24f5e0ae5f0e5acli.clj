(ns ogrim.common.cli
  (:import (java.io BufferedReader InputStreamReader)))

(defn cmd [p] (.. Runtime getRuntime (exec (str p))))

(defn cmd-println [o]
   (let [r (BufferedReader.
              (InputStreamReader.
                (.getInputStream (cmd o))))]
     (dorun (map println (line-seq r)))))

(defn cmd-text [o]
   (let [output (ref [])
         r (BufferedReader.
              (InputStreamReader.
                (.getInputStream (cmd o))))]
     (do (dorun (map #(dosync (alter output conj %)) (line-seq r)))
         @output)))

