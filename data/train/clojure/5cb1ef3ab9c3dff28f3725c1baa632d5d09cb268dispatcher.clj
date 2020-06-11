(ns playground.dispatcher (:require [playground.job :refer :all]
            [playground.taxis  :refer :all]
            [playground.passenger :refer :all]
            [clojure.core.async :as async :refer :all]
            ))



(defn job-assigned [] true)


(defn dispatch-strategy [curr-job taxi-list]
    (println "strategy")
  ; if job is active, move state

  ;
  )

(defn make-dispatch-channel [curr-job taxi-list]
  (let [job-dispatch chan]
    (go-loop [curr-job taxi-list] (<! (timeout 30000))
      (dispatch-strategy  curr-job taxi-list)
      (if (not (job-assigned))
          ;(recur curr-job taxi-list)
          (recur curr-job )
          (println "dispatched")))))




;(defn next-taxi []
;
;  )
;
;
;
;
;(defn dispatch-job [curr-job taxi-list]
;
;  )


