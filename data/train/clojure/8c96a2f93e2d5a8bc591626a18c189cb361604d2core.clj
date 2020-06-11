(ns sodium-clj.core
  "Primary namespace for Sodium interface. Contains all public functions"
  (:refer-clojure :rename {map clj-map filter clj-filter merge clj-merge})
  (:use [sodium-clj.helpers])
  (:import (nz.sodium Stream StreamSink Lazy Tuple2 Handler Cell Transaction)))

;; Public helpers
(defn ->Lazy [arg]
  (Lazy. (if (fn? arg) (->Lambda0 arg) arg)))

(defmacro with-transaction [& body]
  `(Transaction/run
     (->Lambda0 (fn [] ~@body ))))

(defmacro with-void-transaction [& body]
  `(Transaction/runVoid
     (proxy [Runnable] []
       (run [] ~@body))))

(defn on-event [s handler-fn]
  "Call fn on events from Stream s. Returns a Listener which should be stored for later unlistens."
  (.listen s (proxy [Handler] [] (run [v] (handler-fn v)))))

(defn on-event-once [s handler-fn]
  "Call fn on a single event from Stream s. The listener is subsequently removed"
  (.listenOnce s (proxy [Handler] [] (run [v] (handler-fn v)))))

;; Stream creation
(defn ^Stream never []
  (Stream.))

;; Stream funcs
(defn accum [^Stream s init accum-fn]
  "Accumulate Stream events into a Cell"
  (.accum s init (->Lambda2 accum-fn)))

(defn accumLazy [^Stream s init accum-fn]
  "Accumulate Stream events into a Cell using lazy evaluation"
  (.accumLazy s (->Lazy init) (->Lambda2 accum-fn)))

(defn collect [^Stream s init state-fn]
  "Transform Stream events using a general state transition function. state-fn is passed the curent event and
  state value, and should return a tuple of [new-value new-state]"
  (.collect s init (->Lambda2 (fn [event old-state ]
                                (let [[new-value new-state] (state-fn event old-state )]
                                  (Tuple2. new-value new-state))))))

(defn collectLazy [^Stream s init state-fn]
  "Transform Stream events using a general state transition function. state-fn is passed the curent state and
  event value, and should return a tuple of [new-state, new-value]"
  (.collectLazy s (->Lazy init) (->Lambda2 (fn [old-state event]
                                (let [[new-state new-value] (state-fn old-state event)]
                                  (Tuple2. new-state new-value))))))

(defn filter [^Stream s filter-fn]
  "Filter a stream, passing only values for which (filter-fn event) returns true"
  (.filter s (->Lambda1 filter-fn)))

(defn map [^Stream s map-fn]
  "Map a Clojure function over a Stream"
  (.map s (->Lambda1 map-fn)))

(defn merge [s other-s merge-fn]
  (.merge s other-s (->Lambda2 merge-fn)))

(defn snapshot
  ([^Stream s ^Cell c] (.snapshot s c))
  ([^Stream s ^Cell c s-fn] (.snapshot s c (->Lambda2 s-fn)))
  ([^Stream s ^Cell c1 ^Cell c2 s-fn] (.snapshot s c1 c2 (->Lambda3 s-fn)))
  ([^Stream s ^Cell c1 ^Cell c2 ^Cell c3 s-fn] (.snapshot s c1 c2 c3 (->Lambda4 s-fn)))
  ([^Stream s ^Cell c1 ^Cell c2 ^Cell c3 ^Cell c4 s-fn] (.snapshot s c1 c2 c3 c4 (->Lambda5 s-fn)))
  ([^Stream s ^Cell c1 ^Cell c2 ^Cell c3 ^Cell c4 ^Cell c5 s-fn] (.snapshot s c1 c2 c3 c4 c5 (->Lambda6 s-fn)))
  )


