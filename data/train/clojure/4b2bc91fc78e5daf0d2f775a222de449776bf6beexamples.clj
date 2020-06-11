(ns gin.server.examples
  (:require [gin.server.audio :as a]))

(defn example-1
  [& [params]]
  (let [composition   (->> (partition 3 1 (range))
                           (map (fn [[a b c]]
                                  [[a b c] [a]]))
                           flatten)
        stream-params (merge {:ms          (a/seconds->ms (* 60 3))
                              :input-type  :interface
                              :composition composition
                              :buffer-size 2}
                             params)]
    (a/stream! stream-params)))
