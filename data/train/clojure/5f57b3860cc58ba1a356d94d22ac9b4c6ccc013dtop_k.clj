(ns clojurewerkz.streampunk.stream-lib.top-k
  "TopK algorithms from stream-lib"
  (:refer-clojure :exclude [peek])
  (:import  [com.clearspring.analytics.stream ITopK StochasticTopper StreamSummary Counter]))

;;
;; Implementation
;;

(defn counter->map
  [^Counter cnt]
  {:item  (.getItem cnt)
   :count (.getCount cnt)
   :error (.getError cnt)})


;;
;; API
;;

(defn ^StochasticTopper stochastic-topper
  "Instantiates a new Stochastic Topper data structure that implements
   the Top K interface"
  ([sample-size]
     (StochasticTopper. sample-size))
  ([sample-size ^Long seed]
     (StochasticTopper. sample-size seed)))

(defn ^StreamSummary stream-summary
  "Instantiates a new Stream Summary data structure that implements
   the Top K interface"
  [count]
  (StreamSummary. count))

(defn offer
  ([^ITopK algo item]
     (.offer algo item))
  ([^ITopK algo item increment-count]
     (.offer algo item increment-count)))

(defn peek
  [^ITopK algo k]
  (.peek algo k))

(defn top-k
  [^StreamSummary algo k]
  (.topK algo k))

(defn top-k-as-maps
  [^StreamSummary algo k]
  (map counter->map (top-k algo k)))
