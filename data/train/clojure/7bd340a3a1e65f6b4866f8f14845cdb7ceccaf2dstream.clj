(ns peloton.test.stream
  (:use peloton.stream)
  (:use peloton.fut)
  (:use clojure.test))

(deftest stream-test
         (let [s (stream)
               cell (atom 0)]
           (do-stream [i s]
                      (swap! cell + i))
           (s 1)
           (s 2)
           (is (= @cell 3))))

(deftest stream-fut-test
         (let [s (stream)
               cell0 (atom 0)
               cell1 (atom 0)]
           (dofut [f (do-stream [i s] (swap! cell0 inc))]
                  (swap! cell1 inc))
           (s 0)
           (s 1)
           (.close! s)
           (is (= @cell0 2))
           (is (= @cell1 1))))


