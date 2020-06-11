(ns composer.experiments.melody-space
  (:require [composer.composer :refer (compositions)]))

(defn- time-execution
  [f]
  (let [begin (System/currentTimeMillis)
        result (f)
        end (System/currentTimeMillis)]
    {:time (- end begin)
     :result result}))

(defn generate-results
  [n]
  (for [scale [nil :major-scale]
        key [nil :C3]
        cadence [nil :perfect]]
    (let [instrument-state {:scale scale
                            :key key
                            :cadence cadence}
          experiment (fn [] (count
                            (compositions
                             instrument-state n)))
          result (time-execution experiment)]
      (merge instrument-state result {:n n}))))

(defn print-results
  [results]
  (println)

  (doseq [r results]
    (print (get r :scale) ""))
  (println)

  (doseq [r results]
    (print (get r :key) ""))
  (println)

  (doseq [r results]
    (print (get r :cadence) ""))
  (println)

  (println "---------------------------------------------------")

  (doseq [r results]
    (print (get r :result) ""))
  (println)

  (doseq [r results]
    (print (get r :time) ""))
  (println)

  ;; compositions / sec
  (doseq [r results]
    (print (int (/ (:result r) (/ (:time r) 1000))) ""))
  (println))

(defn -main
  [& args]
  (let [n (when (seq args) (-> args first Integer/parseInt))
        results (generate-results n)]
    (println "n =" n)
    (print-results results)))

(comment
  (def results (generate-results 1024))
  (print-results results)

  ;; max tried
  (comment      n (int (Math/pow 2 16))))
