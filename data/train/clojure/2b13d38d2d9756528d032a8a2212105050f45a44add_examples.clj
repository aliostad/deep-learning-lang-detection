(ns dhsr.aaai2015.add-examples
  (:use [common])
  (:use [dhsr.aaai2015.programs])
  (:use [dhsr.aaai2015.streaming-data])
  (:use [dhsr.aaai2015.stream-semantics])
  (:use [dhsr.aaai2015.windows]))

(def a 'a)
(def b 'b)
(def c 'c)
(def d 'd)
(def b1 'b1)
(def b2 'b2)
(def x 'x)
(def y 'y)
(def z 'z)

(def exS12 {:T [1 2], :v {1 #{a}, 2 #{b b1}}})
(def exS23 {:T [2 3], :v {3 #{c}, 2 #{b b2}}})
(def exS14 {:T [1 4], :v {1 #{a}, 3 #{d}}})

(assert (= {:T [1 2], :v {2 #{b1}, 1 #{a}}}
           (stream-minus exS12 exS23)))

(assert (= {:T [2 3], :v {3 #{c}, 2 #{b2}}}
           (stream-minus exS23 exS12)))

(assert (= {:T [1 2], :v {2 #{b b1}}}
           (stream-minus exS12 exS14)))

(assert (= {:T [1 4], :v {3 #{d}}}
           (stream-minus exS14 exS12)))

(assert (= [1 3] (time-points-with-data exS14)))

(assert (= {:T [1 3], :v {1 #{a}, 2 #{b b1 b2}, 3 #{c}}}
           (stream-union exS12 exS23))
        (= (stream-union exS12 exS23)
           (stream-union exS23 exS12)))

;; answer streams

(def P1 #{[x :- a [:not b]]})
(def I1 (stream-union exS12 {:T [1 1], :v {1 #{x}}}))
(def M1 {:stream I1, :data #{}}) ;; empty background data can be omitted

(assert (nil? (model? {:stream exS12, :data #{}} P1 exS12 1)))
(assert (model? {:stream I1, :data #{}} P1 exS12 1))
(assert (minimal-model? {:stream I1, :data #{}} P1 exS12 1))
(assert (answer-stream? I1 {:program P1 :data-stream exS12 :t 1}))

(def P4 #{[c :- a [:not b]] [b :- a [:not c]]})
(def I4b (stream-union exS14 {:T [1 1], :v {1 #{b}}}))
(def I4c (stream-union exS14 {:T [1 1], :v {1 #{c}}}))
(def I4bc (stream-union exS14 {:T [1 1], :v {1 #{b c}}}))
(assert (model? {:stream I4b} P4 exS14 1))
(assert (model? {:stream I4c} P4 exS14 1))
(assert (model? {:stream I4bc} P4 exS14 1))
(assert (minimal-model? {:stream I4b} P4 exS14 1))
(assert (minimal-model? {:stream I4c} P4 exS14 1))
(assert (= false (minimal-model? {:stream I4bc} P4 exS14 1)))
(assert (answer-stream? I4b {:program P4 :data-stream exS14 :t 1}))
(assert (answer-stream? I4c {:program P4 :data-stream exS14 :t 1}))
(assert (nil? (answer-stream? I4bc {:program P4 :data-stream exS14 :t 1})))

;; (assert (minimal-model? {:stream I1, :data #{}} P1 exS12 1))
;; (assert (answer-stream? I1 {:program P1 :data-stream exS12 :t 1}))

;; (def q0
;;   "ground. ==> yes"
;;   {:formula ['bus 'e 'p2]
;;    :time 11})

;; (def q1
;;   "==> X=e P=p2"
;;   {:formula ['bus '?X '?P]
;;    :time 11})

;; (def q2
;;   "==> U=11"
;;   {:formula ['bus 'e 'p2]
;;    :time '?U})

;; (def q3
;;   "==> X=e P=p2 U=11, X=c, P=p1, U=2"
;;   {:formula ['bus '?X '?P]
;;    :time '?U})

;; (def q4
;;   "==> X=tr Y=d U=8, X=bus Y=e U=11. (higher order!)"
;;   {:formula [:window 1 ['?X '?Y 'p2]]
;;    :time '?U})

;; (def q5
;;   "==> X=tr Y=a, X=bus Y=c"
;;   {:formula [:window 1 [:diamond ['?X '?Y 'p1]]]
;;    :time 3})

;; (def q6
;;   "==> ?T=2, ?U=[2,7]"
;;   {:formula [:window 1 [:at '?T ['tr 'a 'p1]]]
;;    :time '?U})

;; (def q7
;;   "==> 1335 substitutions"
;;   {:formula [:at '?T [:window 1 [:diamond [['tr '?X '?P] :or ['bus '?Y '?Q]]]]]
;;    :time 13})

;; (def query1_7_partially_ground
;;   {:formula [:window 1 [[:diamond ['tr '?X 'p2]]
;;                         :and
;;                         [:diamond ['bus '?Y 'p2]]]]
;;    :time '?U})
