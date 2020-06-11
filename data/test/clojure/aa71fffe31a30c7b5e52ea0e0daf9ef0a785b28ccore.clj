(ns ereignis.core
  (:use overtone.at-at)
  (:gen-class))

; filtering

(defn filtr [pred stream]
  (fn [event]
    (when (pred event)
      (stream event))))

; miscellaneous

(defn time-stamp [stream]
  (fn [event]
    (stream 
      (if (contains? event :time) 
        event
        (assoc event :time (now))))))

; pools

; volume pool

(defn overflow [pool volume]
  (if (> (count pool) volume)
    (recur (pop pool) volume) 
    pool))

(defn- update-and-stream 
  [volume stream event pool]
  (let [pool (overflow (conj pool event) volume)]
    (when (= (count pool) volume)
      (future (stream (into [] pool))))
    pool))

(defn volume-pool [volume stream]
  {:pre [(> volume 1)]}
  ; using agent to ensure events enter pool in the order they arrive
  (let [pool-agent (agent clojure.lang.PersistentQueue/EMPTY)]
    (fn [event]
      (send pool-agent 
        (partial update-and-stream volume stream event))
      nil)))

; interval pool

(defn- stream-pool 
  [stream key ref old new]
  (stream new))

(defmacro interval-cond [point [start end] before in after]
  `(cond 
    (> ~point ~end) ~after
    (> ~point ~start) ~in
    :else ~before))

(defn interval-pool 
  ([length stream]
   (interval-pool length 0 stream))
  ([length offset stream]
   {:pre [(> length 0)]}
   (let [pool-atom (atom #{})
         thrd-pool (mk-pool)]
     (add-watch pool-atom nil (partial stream-pool stream))
     (fn [event]
       {:pre [(contains? event :time)]}
       (let [n (now)
             pool-event (fn [pool] (conj pool event))
             un-pool-event (fn [pool] (disj pool event))
             intrvl-end (- n offset)
             intrvl-start (- intrvl-end length)]
         (interval-cond (:time event) [intrvl-start intrvl-end]
           #()
           (do
             (swap! pool-atom pool-event)
             (after (- (:time event) intrvl-start)
               #(swap! pool-atom un-pool-event)
               thrd-pool))
           (do 
             (after (- (:time event) intrvl-end)
               #(swap! pool-atom pool-event)
               thrd-pool)
             nil)
           ))))))

; partition pool

(defn partition-pool [length stream]
  {:pre [(> length 0)]}
  (let [pool-ref (for [i (range 2)] (ref #{}))])
  )

; aggregaton

(defn sum [key stream]
  (fn [events]
    {:pre [(coll? events)]}
    (stream {:value (apply + (map key events)) 
             :events events})))

(defn math-mean [values]
  {:pre [(seq values)]}
  (/ (apply + values) 
     (count values)))

(defn mean [key stream]
  (fn [events]
    {:pre [(coll? events)]}
    (stream {:mean (math-mean (map key events)) 
             :events events})))

; logging

(defn log 
  ([path]
   (log path (fn [_] nil)))
  ([path stream]
   (fn [event]
     (spit path (str event "\n") :append true)   
     (stream event))))
