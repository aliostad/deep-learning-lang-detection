(ns dameon.visual-cortex.stream-tree-test
  (:require
   [dameon.visual-cortex.stream-tree :as t]
   [dameon.visual-cortex.stream :as s])
  (:use
   [clojure.test]))

(deftest add
  (let [tree (t/create)
        s1   (s/->Base-stream [] [] :foo)]
    ;;Exception if the parant with parent-name doesn't exist
    (is (thrown? Exception (t/add tree s1 :bar)))
    ;;Test t/add when t is empty
    (is (= (t/add tree s1) {:paths {:foo [0]} :structure [s1]}))
    ;;Test t/add 2x when t is empty
    (let [s2 (s/->Base-stream [] [] :bar)]
      (is (= (t/add (t/add tree s1 ) s2) {:paths {:foo [0] :bar [1]} :structure [s1 s2]})))
    (let [s-w-upstream (s/->Base-stream [(assoc s1 :name :bar)] [] :foo)]
      (is (= (t/add (t/add tree s1)  (s/->Base-stream [] [] :bar) :foo)
             {:paths {:foo [0] :bar [0 0]} :structure [s-w-upstream]})))))


(deftest delete
  (let [tree
        (-> (t/create)
            (t/add (s/->Base-stream [] [] :foo))
            (t/add (s/->Base-stream [] [] :bar))
            (t/add (s/->Base-stream [] [] :baz) :bar))]

;;; Types of interactions

    ;; - Delete a node that has no children
    (is (=
         (t/delete tree :baz)
         (-> (t/create)
              (t/add (s/->Base-stream [] [] :foo))
              (t/add (s/->Base-stream [] [] :bar)))))
    ;; - Delete a node that has a child
    (is (=
         (t/delete tree :bar)
         (-> (t/create)
             (t/add (s/->Base-stream [] [] :foo)))))

    ;; - Delete a node that will shift all other nodes
    (is (=
         (t/delete tree :foo)
         (-> (t/create)
             (t/add (s/->Base-stream [] [] :bar))
             (t/add (s/->Base-stream [] [] :baz) :bar))))))



















