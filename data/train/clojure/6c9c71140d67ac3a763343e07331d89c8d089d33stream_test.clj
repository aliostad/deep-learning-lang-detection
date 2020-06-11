(ns logjure.utils.stream-test
  (:use 
    logjure.utils.pair
    logjure.utils.stream
    clojure.test
    )
  )

(deftest test-empty-stream
  (is (= nil the-empty-stream))
)

(deftest test-stream-null?
  (is (= true (stream-null? nil)))
)

(deftest test-cons-stream
  (is (= :a (stream-car (cons-stream :a the-empty-stream))))
  (is (= the-empty-stream (stream-cdr (cons-stream :a the-empty-stream))))
)

(deftest test-singleton-stream
  (is (= :a (stream-car (singleton-stream :a))))
  (is (= the-empty-stream (stream-cdr (singleton-stream :a))))
)

(deftest test-stream-nth
  (let [s (cons-stream :a (cons-stream :b (singleton-stream :c)))] 
    (is (= :a (stream-nth 0 s)))
    (is (= :b (stream-nth 1 s)))
    (is (= :c (stream-nth 2 s)))
    (is (= the-empty-stream (stream-nth 3 s)))
    (is (= 10001 (stream-nth 10000 (seq-to-stream (iterate inc 1)))))
  )
)

(deftest test-seq-to-stream
  (let [s (seq-to-stream '(1 2 3))] 
    (is (= 1 (stream-nth 0 s)))
    (is (= 2 (stream-nth 1 s)))
    (is (= 3 (stream-nth 2 s)))
    (is (= the-empty-stream (stream-nth 3 s)))
  )
  (is (= 1 (stream-nth 0 (seq-to-stream (iterate inc 1)))))
  (is (= 2 (stream-nth 1 (seq-to-stream (iterate inc 1)))))
  (is (= 10001 (stream-nth 10000 (seq-to-stream (iterate inc 1)))))
)

(deftest test-stream-to-seq
  (is (= '() (stream-to-seq the-empty-stream)))
  (let [s (stream-to-seq (seq-to-stream '(1 2 3)))] 
    (is (= 1 (nth s 0)))
    (is (= 2 (nth s 1)))
    (is (= 3 (nth s 2)))
    (is (= :not-found (nth s 3 :not-found)))
  )
  (is (= 1 (nth (stream-to-seq (seq-to-stream (iterate inc 1))) 0)))
  (is (= 2 (nth (stream-to-seq (seq-to-stream (iterate inc 1))) 1)))
  (is (= 10001 (nth (stream-to-seq (seq-to-stream (iterate inc 1))) 10000)))
)

(deftest test-stream-append
  (let [s (stream-append (cons-stream :a (singleton-stream :b)) (singleton-stream :x))] 
    (is (= :a (stream-car s)))
    (is (= :b (stream-car (stream-cdr s))))
    (is (= :x (stream-car (stream-cdr (stream-cdr s)))))
    (is (= the-empty-stream (stream-car (stream-cdr (stream-cdr (stream-cdr s))))))
    (is (= :x (stream-nth 10000 (stream-append (seq-to-stream (take 10000 (iterate inc 1))) (singleton-stream :x)))))
  )
)

(deftest test-stream-append-delayed
  (let [s (stream-append-delayed (cons-stream :a (singleton-stream :b)) (singleton-stream :x))] 
    (is (= :a (stream-car s)))
    (is (= :b (stream-car (stream-cdr s))))
    (is (= :x (stream-car (stream-cdr (stream-cdr s)))))
    (is (= the-empty-stream (stream-car (stream-cdr (stream-cdr (stream-cdr s))))))
    (is (= :x (stream-nth 10000 (stream-append-delayed (seq-to-stream (take 10000 (iterate inc 1))) (singleton-stream :x)))))
  )
)

(deftest test-interleave-delayed
  (let [s1 (cons-stream :a (cons-stream :b (cons-stream :c (singleton-stream :d))))
        s2 (cons-stream :x (cons-stream :y (cons-stream :z (singleton-stream :zz))))
        s (interleave-delayed s1 s2)] 
    (is (= :a (stream-car s)))
    (is (= :x (stream-car (stream-cdr s))))
    (is (= :b (stream-car (stream-cdr (stream-cdr s)))))
    (is (= :y (stream-car (stream-cdr (stream-cdr (stream-cdr s))))))
    (is (= :c (stream-car (stream-cdr (stream-cdr (stream-cdr (stream-cdr s)))))))
    (is (= :z (stream-car (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr s))))))))
    (is (= :d (stream-car (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr s)))))))))
    (is (= :zz (stream-car (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr s))))))))))
    (is (= the-empty-stream (stream-car (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr s)))))))))))
    )
  (let [s1 (seq-to-stream (iterate inc 1))
        s2 (seq-to-stream (repeat :a))
        s (interleave-delayed s1 s2)]
    (is (= 1 (stream-nth 0 s)))
    (is (= :a (stream-nth 1 s)))
    (is (= 2 (stream-nth 2 s)))
    (is (= :a (stream-nth 3 s)))
    (is (= 3 (stream-nth 4 s)))
    (is (= 5001 (stream-nth 10000 s)))
    (is (= :a (stream-nth 10001 s)))
    )
  )

(deftest test-flatten-interleave-stream-2
  (let [s1 (cons-stream :a (cons-stream :b (cons-stream :c (singleton-stream :d))))
        s2 (cons-stream :x (cons-stream :y (cons-stream :z (singleton-stream :zz))))
        sX (cons-stream s1 (singleton-stream s2));stream of streams
        s (flatten-interleave-stream sX)
        ] 
    (is (= :a (stream-car s)))
    (is (= :x (stream-car (stream-cdr s))))
    (is (= :b (stream-car (stream-cdr (stream-cdr s)))))
    (is (= :y (stream-car (stream-cdr (stream-cdr (stream-cdr s))))))
    (is (= :c (stream-car (stream-cdr (stream-cdr (stream-cdr (stream-cdr s)))))))
    (is (= :z (stream-car (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr s))))))))
    (is (= :d (stream-car (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr s)))))))))
    (is (= :zz (stream-car (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr s))))))))))
    (is (= the-empty-stream (stream-car (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr s)))))))))))
    )
  )

(deftest test-flatten-interleave-stream-3
  (let [s1 (cons-stream :a (cons-stream :b (singleton-stream :c)))
        s2 (cons-stream :x (cons-stream :y (singleton-stream :z)))
        s3 (cons-stream 1 (cons-stream 2 (singleton-stream 3)))
        sX (cons-stream s1 (cons-stream s2 (singleton-stream s3)));stream of streams
        s (flatten-interleave-stream sX)
        ] 
    (is (= :a (stream-car s)))
    (is (= :x (stream-car (stream-cdr s))))
    (is (= :b (stream-car (stream-cdr (stream-cdr s)))))
    (is (= 1 (stream-car (stream-cdr (stream-cdr (stream-cdr s))))))
    (is (= :c (stream-car (stream-cdr (stream-cdr (stream-cdr (stream-cdr s)))))))
    (is (= :y (stream-car (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr s))))))))
    (is (= 2 (stream-car (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr s)))))))))
    (is (= :z (stream-car (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr s))))))))))
    (is (= 3 (stream-car (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr s)))))))))))
    (is (= the-empty-stream (stream-car (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr s))))))))))))
    )
  )

(deftest test-flatten-interleave-stream-1-infinite
  (let [s1 (seq-to-stream (iterate inc 1))
        sX (cons-stream s1 the-empty-stream);stream of streams
        s (flatten-interleave-stream sX)]
    (is (= 1 (stream-nth 0 s)))
    (is (= 2 (stream-nth 1 s)))
    (is (= 10001 (stream-nth 10000 s)))
    )
  )

(deftest test-flatten-interleave-stream-2-infinite
  (let [s1 (seq-to-stream (iterate inc 1))
        s2 (seq-to-stream (repeat :a))
        sX (cons-stream s1 (cons-stream s2 the-empty-stream));stream of streams
        s (flatten-interleave-stream sX)]
    (is (= 1 (stream-nth 0 s)))
    (is (= :a (stream-nth 1 s)))
    (is (= 2 (stream-nth 2 s)))
    (is (= :a (stream-nth 3 s)))
    (is (= 5001 (stream-nth 10000 s)))
    (is (= :a (stream-nth 10001 s)))
    )
  )

(deftest test-flatten-interleave-stream-3-infinite
  (let [s1 (seq-to-stream (iterate inc 1))
        s2 (seq-to-stream (repeat :a))
        s3 (seq-to-stream (repeat :x))
        sX (cons-stream s1 (cons-stream s2 (singleton-stream s3)));stream of streams
        s (flatten-interleave-stream sX)]
    (is (= 1 (stream-nth 0 s)))
    (is (= :a (stream-nth 1 s)))
    (is (= 2 (stream-nth 2 s)))
    (is (= :x (stream-nth 3 s)))
    (is (= 3 (stream-nth 4 s)))
    (is (= :a (stream-nth 5 s)))
    (is (= 4 (stream-nth 6 s)))
    (is (= :x (stream-nth 7 s)))
    (is (= 5 (stream-nth 8 s)))
    (is (= 5001 (stream-nth 10000 s)))
    (is (= :a (stream-nth 10001 s)))
    (is (= 5002 (stream-nth 10002 s)))
    (is (= :x (stream-nth 10003 s)))
    )
  )

(deftest test-flatten-interleave-stream-infinite-of-infinites
  "
1: 1 2 3 4 5 6 7 8 9 ...
2: 1 2 3 4 5 6 7 8 9 ...
3: 1 2 3 4 5 6 7 8 9 ...
4: 1 2 3 4 5 6 7 8 9 ...
5: 1 2 3 4 5 6 7 8 9 ...
6: 1 2 3 4 5 6 7 8 9 ...
...
"
  (let [create-infinite-stream 
        (fn create-infinite-stream [i] (stream-map (fn [n] [i n]) (seq-to-stream (iterate inc 1))))
        sX (stream-map create-infinite-stream (seq-to-stream (iterate inc 1)));infinite stream of infinite streams
        s (flatten-interleave-stream sX)]
    (is (= [1 1] (stream-nth 0 s)))
    (is (= [2 1] (stream-nth 1 s)))
    (is (= [1 2] (stream-nth 2 s)))
    (is (= [3 1] (stream-nth 3 s)))
    (is (= [1 3] (stream-nth 4 s)))
    (is (= [2 2] (stream-nth 5 s)))
    (is (= [1 4] (stream-nth 6 s)))
    (is (= [4 1] (stream-nth 7 s)))
    (is (= [1 5001] (stream-nth 10000 s)))
    (is (= [2 2501] (stream-nth 10001 s)))
    (is (= [1 5002] (stream-nth 10002 s)))
    (is (= [3 1251] (stream-nth 10003 s)))
    (is (= [1 5003] (stream-nth 10004 s)))
    (is (= [2 2502] (stream-nth 10005 s)))
    (is (= [1 5004] (stream-nth 10006 s)))
    (is (= [4  626] (stream-nth 10007 s)))
    )
  )

(deftest test-flatten-stream-1-infinite
  (let [s1 (seq-to-stream (iterate inc 1))
        sX (cons-stream s1 the-empty-stream);stream of streams
        s (flatten-stream sX)]
    (is (= 1 (stream-nth 0 s)))
    (is (= 2 (stream-nth 1 s)))
    (is (= 10001 (stream-nth 10000 s)))
    )
  )

(deftest test-flatten-stream-2
  (let [s1 (seq-to-stream (take 3 (iterate inc 1)))
        s2 (seq-to-stream (repeat :a))
        sX (cons-stream s1 (cons-stream s2 the-empty-stream));stream of streams
        s (flatten-stream sX)]
    (is (= 1 (stream-nth 0 s)))
    (is (= 2 (stream-nth 1 s)))
    (is (= 3 (stream-nth 2 s)))
    (is (= :a (stream-nth 4 s)))
    (is (= :a (stream-nth 10000 s)))
    (is (= :a (stream-nth 10001 s)))
    )
  )

(deftest test-flatten-stream-3
  (let [s1 (seq-to-stream (take 3(iterate inc 1)))
        s2 (seq-to-stream (take 3 (repeat :a)))
        s3 (seq-to-stream (iterate inc 1))
        sX (cons-stream s1 (cons-stream s2 (singleton-stream s3)));stream of streams
        s (flatten-stream sX)]
    (is (= 1 (stream-nth 0 s)))
    (is (= 2 (stream-nth 1 s)))
    (is (= 3 (stream-nth 2 s)))
    (is (= :a (stream-nth 3 s)))
    (is (= :a (stream-nth 4 s)))
    (is (= :a (stream-nth 5 s)))
    (is (= 1 (stream-nth 6 s)))
    (is (= 10000 (stream-nth 10005 s)))
    )
  )

(deftest test-stream-map
  (let [s (stream-map #(+ % 10) (cons-stream 1 (cons-stream 2 (singleton-stream 3))))] 
    (is (= 11 (stream-car s)))
    (is (= 12 (stream-car (stream-cdr s))))
    (is (= 13 (stream-car (stream-cdr (stream-cdr s)))))
    (is (= the-empty-stream (stream-car (stream-cdr (stream-cdr (stream-cdr s))))))
  )
)

(deftest test-stream-map-infinite
  (let [s (stream-map #(+ % 10) (seq-to-stream (iterate inc 1)))] 
    (is (= 11 (stream-nth 0 s)))
    (is (= 10011 (stream-nth 10000 s)))
  )
)

(deftest test-stream-map-proc-vector
  (let [s (stream-map (fn [x] [x :a]) (seq-to-stream (iterate inc 1)))] 
    (is (= [1 :a] (stream-nth 0 s)))
    (is (= [10001 :a] (stream-nth 10000 s)))
  )
)

(deftest test-stream-flatmap-interleave
  (let [s1 (cons-stream 1 (cons-stream 2 (cons-stream 3 (singleton-stream 4))))
        s (flatten-interleave-stream (stream-map #(cons-stream % s1) s1))
        ;1 1 2 3 4
        ;2 1 2 3 4
        ;3 1 2 3 4
        ;4 1 2 3 4
        ] 
    (is (= 1 (stream-car s)))
    (is (= 2 (stream-car (stream-cdr s))))
    (is (= 1 (stream-car (stream-cdr (stream-cdr s)))))
    (is (= 3 (stream-car (stream-cdr (stream-cdr (stream-cdr s))))))
    (is (= 2 (stream-car (stream-cdr (stream-cdr (stream-cdr (stream-cdr s)))))))
    (is (= 1 (stream-car (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr s))))))))
    (is (= 3 (stream-car (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr (stream-cdr s)))))))))
    )
  )

(run-tests)
