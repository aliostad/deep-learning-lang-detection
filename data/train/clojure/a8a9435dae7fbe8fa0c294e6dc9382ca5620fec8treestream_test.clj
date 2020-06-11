(ns logjure.utils.treestream-test
  (:use 
    logjure.utils.stream
    logjure.utils.treenode
    logjure.utils.lazytree
    logjure.utils.treeseq
    logjure.utils.treestream
    logjure.utils.testing 
    clojure.test
    )
  )

;duplicated from treeseq_test.clj
(defn test-tree-stream-breadth 
  []
  (let [tree-stream-breadth-seq (comp stream-to-seq tree-stream-breadth)]
    (is (= '(:a) (doall (tree-stream-breadth-seq :a))))
    (is (= '(()) (doall (tree-stream-breadth-seq '()))))
    (is (= '((:a) :a) (doall (tree-stream-breadth-seq '(:a)))))
    (is (= '((:a :b :c) :a :b :c) (doall (tree-stream-breadth-seq '(:a :b :c)))))
    (is (= '((:a (:b) :c) :a (:b) :c :b) (doall (tree-stream-breadth-seq '(:a (:b) :c)))))
    (is (= '((:a :b (:c)) :a :b (:c) :c) (doall (tree-stream-breadth-seq '(:a :b (:c))))))
    (is (= '((:a (:b (:x)) :c) :a (:b (:x)) :c :b (:x) :x) (doall (tree-stream-breadth-seq '(:a (:b (:x)) :c)))))
    (is (= '((:a ((:x) :b) :c) :a ((:x) :b) :c (:x) :b :x) (doall (tree-stream-breadth-seq '(:a ((:x) :b) :c)))))
    (is (= '((:a ((:x) :b) ((:y) :c) :d) :a ((:x) :b) ((:y) :c) :d (:x) :b (:y) :c :x :y) 
           (doall (tree-stream-breadth-seq '(:a ((:x) :b) ((:y) :c) :d)))))
    (is (= '(:a :c :b :x) (doall (filter is-leaf (tree-stream-breadth-seq '(:a ((:x) :b) :c))))))
    (is (= '(
              (:a ((:x) :b) :c ((:y) :d) :e)
              :a ((:x) :b) :c ((:y) :d) :e
              (:x) :b (:y) :d
              :x :y
              ) 
           (doall (tree-stream-breadth-seq '(:a ((:x) :b) :c ((:y) :d) :e)))))
    (is (= '(:a :c :e :b :d :x :y) (doall (filter is-leaf (tree-stream-breadth-seq '(:a ((:x) :b) :c ((:y) :d) :e))))))
    ;test that no stack overflow; passes 100000
    (is (= '(:bottom) (doall (filter is-leaf (tree-stream-breadth-seq (deeply-nested 10000))))))
    )
  )

(deftest test-tree-stream-breadth-lazines
  ;test laziness
  ;level 0 (root)
  (is (= '[(:a ((:x) :b) :c ((:y) :d) :e) 
           []] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-breadth '(:a ((:x) :b) :c ((:y) :d) :e)) 0 :not-found))))
  ;level 1
  (is (= '[:a 
           [(:a ((:x) :b) :c ((:y) :d) :e)]] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-breadth '(:a ((:x) :b) :c ((:y) :d) :e)) 1 :not-found))))
  (is (= '[((:x) :b) 
           [(:a ((:x) :b) :c ((:y) :d) :e)]] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-breadth '(:a ((:x) :b) :c ((:y) :d) :e)) 2 :not-found))))
  (is (= '[:c 
           [(:a ((:x) :b) :c ((:y) :d) :e)]] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-breadth '(:a ((:x) :b) :c ((:y) :d) :e)) 3 :not-found))))
  (is (= '[((:y) :d) 
           [(:a ((:x) :b) :c ((:y) :d) :e)]] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-breadth '(:a ((:x) :b) :c ((:y) :d) :e)) 4 :not-found))))
  (is (= '[:e 
           [(:a ((:x) :b) :c ((:y) :d) :e)]] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-breadth '(:a ((:x) :b) :c ((:y) :d) :e)) 5 :not-found))))
  ;level 2
  (is (= '[(:x) 
           [(:a ((:x) :b) :c ((:y) :d) :e) :a ((:x) :b)]] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-breadth '(:a ((:x) :b) :c ((:y) :d) :e)) 6 :not-found))))
  (is (= '[:b 
           [(:a ((:x) :b) :c ((:y) :d) :e) :a ((:x) :b)]] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-breadth '(:a ((:x) :b) :c ((:y) :d) :e)) 7 :not-found))))
  (is (= '[(:y) 
           [(:a ((:x) :b) :c ((:y) :d) :e) :a ((:x) :b) :c ((:y) :d)]] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-breadth '(:a ((:x) :b) :c ((:y) :d) :e)) 8 :not-found))))
  (is (= '[:d 
           [(:a ((:x) :b) :c ((:y) :d) :e) :a ((:x) :b) :c ((:y) :d)]] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-breadth '(:a ((:x) :b) :c ((:y) :d) :e)) 9 :not-found))))
  ;level 3
  (is (= '[:x 
           [(:a ((:x) :b) :c ((:y) :d) :e) :a ((:x) :b) :c ((:y) :d) :e (:x)]] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-breadth '(:a ((:x) :b) :c ((:y) :d) :e)) 10 :not-found))))
  (is (= '[:y 
           [(:a ((:x) :b) :c ((:y) :d) :e) :a ((:x) :b) :c ((:y) :d) :e (:x) :b (:y)]] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-breadth '(:a ((:x) :b) :c ((:y) :d) :e)) 11 :not-found))))
  ;not found
  (is (= '[:not-found 
           [(:a ((:x) :b) :c ((:y) :d) :e) :a ((:x) :b) :c ((:y) :d) :e (:x) :b (:y) :d :x :y]] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-breadth '(:a ((:x) :b) :c ((:y) :d) :e)) 12 :not-found))))
  ;all
  (is (= '[(
            (:a ((:x) :b) :c ((:y) :d) :e)
            :a ((:x) :b) :c ((:y) :d) :e
            (:x) :b (:y) :d
            :x :y
            ) 
           [(:a ((:x) :b) :c ((:y) :d) :e) :a ((:x) :b) :c ((:y) :d) :e (:x) :b (:y) :d :x :y]] 
         (recorder get-children get-child-seq (doall (stream-to-seq (tree-stream-breadth '(:a ((:x) :b) :c ((:y) :d) :e)))))))
  )

(deftest test-tree-stream-depth
  (let [tree-stream-depth-seq (comp stream-to-seq tree-stream-depth)]
    (is (= '(:a) (doall (tree-stream-depth-seq :a))))
    (is (= '(()) (doall (tree-stream-depth-seq '()))))
    (is (= '((:a) :a) (doall (tree-stream-depth-seq '(:a)))))
    (is (= '((:a :b :c) :a :b :c) (doall (tree-stream-depth-seq '(:a :b :c)))))
    (is (= '((:a (:b) :c) :a (:b) :b :c) (doall (tree-stream-depth-seq '(:a (:b) :c)))))
    (is (= '((:a (:b (:x)) :c) :a (:b (:x)) :b (:x) :x :c) (doall (tree-stream-depth-seq '(:a (:b (:x)) :c)))))
    (is (= '(:a :b :x :c) (doall (filter is-leaf (tree-stream-depth-seq '(:a (:b (:x)) :c))))))
    ;test that no stack overflow; passes 100000
    (is (= '(:bottom) (doall (filter is-leaf (tree-stream-depth-seq (deeply-nested 10000))))))
    )
  )

(deftest test-tree-stream-depth-lazy
  ;test laziness
  (is (= '[(:a ((:x) :b) :c ((:y) :d) :e) 
           []] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-depth '(:a ((:x) :b) :c ((:y) :d) :e)) 0 :not-found))))
  (is (= '[:a 
           [(:a ((:x) :b) :c ((:y) :d) :e)]] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-depth '(:a ((:x) :b) :c ((:y) :d) :e)) 1 :not-found))))
  (is (= '[((:x) :b) 
           [(:a ((:x) :b) :c ((:y) :d) :e) :a]] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-depth '(:a ((:x) :b) :c ((:y) :d) :e)) 2 :not-found))))
  (is (= '[(:x)
           [(:a ((:x) :b) :c ((:y) :d) :e) :a ((:x) :b)]] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-depth '(:a ((:x) :b) :c ((:y) :d) :e)) 3 :not-found))))
  (is (= '[:x 
           [(:a ((:x) :b) :c ((:y) :d) :e) :a ((:x) :b) (:x)]] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-depth '(:a ((:x) :b) :c ((:y) :d) :e)) 4 :not-found))))
  (is (= '[:b
           [(:a ((:x) :b) :c ((:y) :d) :e) :a ((:x) :b) (:x) :x]] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-depth '(:a ((:x) :b) :c ((:y) :d) :e)) 5 :not-found))))
  (is (= '[:c
           [(:a ((:x) :b) :c ((:y) :d) :e) :a ((:x) :b) (:x) :x :b]] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-depth '(:a ((:x) :b) :c ((:y) :d) :e)) 6 :not-found))))
  (is (= '[((:y) :d)
           [(:a ((:x) :b) :c ((:y) :d) :e) :a ((:x) :b) (:x) :x :b :c]] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-depth '(:a ((:x) :b) :c ((:y) :d) :e)) 7 :not-found))))
  (is (= '[(:y)
           [(:a ((:x) :b) :c ((:y) :d) :e) :a ((:x) :b) (:x) :x :b :c ((:y) :d)]] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-depth '(:a ((:x) :b) :c ((:y) :d) :e)) 8 :not-found))))
  (is (= '[:y
           [(:a ((:x) :b) :c ((:y) :d) :e) :a ((:x) :b) (:x) :x :b :c ((:y) :d) (:y)]] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-depth '(:a ((:x) :b) :c ((:y) :d) :e)) 9 :not-found))))
  (is (= '[:d
           [(:a ((:x) :b) :c ((:y) :d) :e) :a ((:x) :b) (:x) :x :b :c ((:y) :d) (:y) :y]] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-depth '(:a ((:x) :b) :c ((:y) :d) :e)) 10 :not-found))))
  (is (= '[:e
           [(:a ((:x) :b) :c ((:y) :d) :e) :a ((:x) :b) (:x) :x :b :c ((:y) :d) (:y) :y :d]] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-depth '(:a ((:x) :b) :c ((:y) :d) :e)) 11 :not-found))))
  (is (= '[:not-found
           [(:a ((:x) :b) :c ((:y) :d) :e) :a ((:x) :b) (:x) :x :b :c ((:y) :d) (:y) :y :d :e]] 
         (recorder get-children get-child-seq (stream-nth-2 (tree-stream-depth '(:a ((:x) :b) :c ((:y) :d) :e)) 12 :not-found))))
  (is (= '[((:a ((:x) :b) :c ((:y) :d) :e) :a ((:x) :b) (:x) :x :b :c ((:y) :d) (:y) :y :d :e)
           [(:a ((:x) :b) :c ((:y) :d) :e) :a ((:x) :b) (:x) :x :b :c ((:y) :d) (:y) :y :d :e]] 
         (recorder get-children get-child-seq (doall (stream-to-seq (tree-stream-depth '(:a ((:x) :b) :c ((:y) :d) :e)))))))
  )

(deftest test-tree-stream-interleave
  (let [tree-stream-interleave-seq (comp stream-to-seq tree-stream-interleave)]
    (is (= '(:a) (doall (tree-stream-interleave-seq :a))))
    (is (= '(()) (doall (tree-stream-interleave-seq '()))))
    (is (= '((:a) :a) (doall (tree-stream-interleave-seq '(:a)))))
    (is (= '((:a :b :c) :a :b :c) (doall (tree-stream-interleave-seq '(:a :b :c)))))
    (is (= '((:a (:b) :c) :a :b (:b) :c) (doall (tree-stream-interleave-seq '(:a (:b) :c)))))
    (is (= '((:a :b (:c)) :a :c :b (:c)) (doall (tree-stream-interleave-seq '(:a :b (:c))))))
    (is (= '((:a (:b (:x)) :c) :a :b (:b (:x)) :x :c (:x)) (doall (tree-stream-interleave-seq '(:a (:b (:x)) :c)))))
    (is (= '((:a ((:x) :b) :c) :a (:x) ((:x) :b) :x :c :b) (doall (tree-stream-interleave-seq '(:a ((:x) :b) :c)))))
    (is (= '((:a ((:x) :b) ((:y) :c) :d) :a (:x) ((:x) :b) :x ((:y) :c) (:y) :d :y :b :c) 
           (doall (tree-stream-interleave-seq '(:a ((:x) :b) ((:y) :c) :d)))))
    (is (= '(:a :x :c :b) (doall (filter is-leaf (tree-stream-interleave-seq '(:a ((:x) :b) :c))))))
    (is (= '((:a ((:x) :b) :c ((:y) :d) :e) :a (:x) ((:x) :b) :x :c (:y) ((:y) :d) :y :e :b :d) 
           (doall (tree-stream-interleave-seq '(:a ((:x) :b) :c ((:y) :d) :e)))))
    (is (= '(:a :x :c :y :e :b :d) (doall (filter is-leaf (tree-stream-interleave-seq '(:a ((:x) :b) :c ((:y) :d) :e))))))
    ;test that no stack overflow; passes 100000
    (is (= '(:bottom) (doall (filter is-leaf (tree-stream-interleave-seq (deeply-nested 10000))))))
    ;test laziness
    ;level 0 (root)
    (is (= '[(:a ((:x) :b) :c ((:y) :d) :e) [(:a ((:x) :b) :c ((:y) :d) :e)]] 
           (recorder get-children get-child-seq (nth (tree-stream-interleave-seq '(:a ((:x) :b) :c ((:y) :d) :e)) 0 :not-found))))
    )
  )

(deftest test-tree-stream-interleave-infinite-tree
  (let [tree-stream-interleave-seq (comp stream-to-seq tree-stream-interleave)
        s (tree-stream-interleave-seq (create-infinite-tree))]
    (is (= [1] (node-get-value (nth s 0))))
    (is (= [1 1] (node-get-value (nth s 1))))
    (is (= [1 1 1] (node-get-value (nth s 2))))
    (is (= [1 2] (node-get-value (nth s 3))))
    (is (= [1 1 1 1] (node-get-value (nth s 4))))
    (is (= [1 3] (node-get-value (nth s 5))))
    (is (= [1 2 1] (node-get-value (nth s 6))))
    (is (= [1 4] (node-get-value (nth s 7))))
    (is (= [1 1 1 1 1] (node-get-value (nth s 8))))
    (is (= [1 5] (node-get-value (nth s 9))))
    (is (= [1 1 2] (node-get-value (nth s 10))))
    (is (= [1 1 1 1 1 157] (node-get-value (nth s 10000))))
    (is (= [1 5001] (node-get-value (nth s 10001))))
    (is (= [1 1 1251] (node-get-value (nth s 10002))))
    (is (= [1 5002] (node-get-value (nth s 10003))))
    (is (= [1 1 1 626] (node-get-value (nth s 10004))))
    (is (= [1 5003] (node-get-value (nth s 10005))))
    (is (= [1 2 626] (node-get-value (nth s 10006))))
    (is (= [1 5004] (node-get-value (nth s 10007))))
  )
)

(run-tests)
