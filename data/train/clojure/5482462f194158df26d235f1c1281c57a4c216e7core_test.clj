(ns sodium-clj.core-test
  (:require [clojure.test :refer :all]
            [sodium-clj.core :as s]
            [sodium-clj.helpers :refer :all])
  (:import (nz.sodium StreamSink Stream Cell)))

(defn into-streams [build-fn]
  (let [sink (StreamSink.)]
    [sink (build-fn sink)]))

(defn collect-events [events hd tail collect-fn]
  (let [hdsv (if (coll? hd) hd [hd])
        eventsv (if (coll? hd) events (map #(vector %1) events))
        a (atom [])
        l (s/on-event tail (fn [e] (swap! a collect-fn e)))]
    (try
      (doseq [es eventsv]
        (s/with-void-transaction
          (doall (map (fn [e s] (.send e s)) hdsv es))))
      (finally (.unlisten l)))
    @a))

(defn send-events [events [hd tail]]
  (collect-events events hd tail
    (if (instance? Cell tail)
      (fn [_ e] e)
      (fn [v e] (conj v e)))))

(deftest helpers
  (testing "with-transaction"
    (is (= (s/with-transaction
             (inc 0))
          1))
    (is (nil? (s/with-void-transaction (inc 0))))
    ))

(deftest transformations
  (testing "accum"
    (is (instance? Cell (-> (StreamSink.) (s/accum 0 +))))
    (is (= (send-events [0 1 2]
             (into-streams
               #(-> %1
                 (s/accum 0 +))))
          3))
    (is (instance? Cell (-> (StreamSink.) (s/accumLazy 0 +))))
    (is (= (send-events [0 1 2]
             (into-streams
               #(-> %1
                 (s/accumLazy 0 +))))
          3))
    )
  (testing "collect"
    (is (instance? Stream (-> (StreamSink.) (s/collect :a #(vector %1 [%1 %2])))))
    (is (= (send-events [0 1]
             (into-streams
               #(-> %1
                 (s/collect :a (fn [v s] (vector [(inc v) s] s))))))
          [[1 :a] [2 :a]]))
    (is (instance? Stream (-> (StreamSink.) (s/collectLazy :a #(vector %1 [%1 %2])))))
    (is (= (send-events [0 1]
             (into-streams
               #(-> %1
                 (s/collectLazy :a (fn [v s] (vector [(inc v) s] s))))))
          [[1 :a] [2 :a]]))
    )
  (testing "filter"
    (is (instance? Stream (-> (StreamSink.) (s/filter even?))))
    (is (= (send-events [0 1 2 3 4]
             (into-streams
               #(-> %1
                 (s/filter even?))))
          [0 2 4])))

  (testing "map"
    (is (instance? Stream (-> (StreamSink.) (s/map inc))))
    (is (=
          (send-events [0 1 2]
            (into-streams
              #(-> %1
                (s/map inc))))
          [1 2 3]))
    )

  (testing "merge single"
    (is (instance? Stream (-> (StreamSink.) (s/merge (s/never) (fn [l r] l)))))
    (is (=
          (send-events [[0 1] [1 2] [2 3]]
            (let [s1 (StreamSink.)
                  s2 (StreamSink.)
                  s (s/merge s1 s2 (fn [l r] l))]
              [[s1 s2] s]
              ))
          [0 1 2]))
    (is (=
          (send-events [[0 1] [1 2] [2 3]]
            (let [s1 (StreamSink.)
                  s2 (StreamSink.)
                  s (s/merge s1 s2 (fn [l r] r))]
              [[s1 s2] s]
              ))
          [1 2 3]))
    )

  (testing "snapshot"
    (is (instance? Stream (-> (StreamSink.) (s/snapshot (Cell. 0)))))
    (is (= (send-events [0 1 2 3 4]
             (into-streams
               #(-> %1
                 (s/snapshot (Cell. 0)))))
          [0 0 0 0 0]))
    (is (= (send-events [0 1 2 3 4]
             (into-streams
               #(-> %1
                 (s/snapshot (Cell. 1) +))))
          [1 2 3 4 5]))
    (doseq [n (range 2 6)]
      (is (= (send-events [0]
               (into-streams
                 #(apply s/snapshot %1  (concat (map (fn [_] (Cell. 1)) (range 0 n)) [+]))))
            [n])))
    )

  )
