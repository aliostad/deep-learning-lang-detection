(ns immutant-hystrix-stream.stream
  (:require [immutant-hystrix-stream.metrics :as metrics]
            [immutant-hystrix-stream.json :refer :all])
  (:require [cheshire.core :as json])
  (:require [immutant.web.sse :refer [as-channel send! Event]]))

(extend-protocol Event
  nil
  (event->str [_] "ping:\n")
  com.netflix.hystrix.HystrixMetrics
  (event->str [m] (str "data:" (json/encode m) "\n")))

(defn hystrix-stream
  [request]
  (as-channel request
              {:on-open (fn [ch]
                          (while true
                            (let [m (metrics/all-metrics)]
                              (if (empty? m)
                                (send! ch nil)
                                (doall (map (partial send! ch) m))))
                            (Thread/sleep 500)))}))
