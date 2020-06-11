(ns clj3manchess.engine.move-test
  (:require [clj3manchess.engine.move :as sut :refer [eval-death]]
            #?(:clj [clojure.test :as t]
               :cljs [cljs.test :as t :include-macros true])
            #?(:clj [clojure.spec.test :as stest]
               :cljs [cljs.spec.test :as stest])
            [clj3manchess.engine.state :as st]
            [clj3manchess.engine.board :as b]))

(stest/instrument `sut/to)
(stest/instrument `sut/get-bef-sq)
(stest/instrument `sut/impos-chain)
(stest/instrument `b/getb)
(stest/instrument `sut/can-i-move-wo-check)

(t/deftest eval-death-rem-king-gray []
  (t/is (= (:alive (eval-death (assoc st/newgame :board [::b/newgame {[0 12] nil}])))
           #{:white :black})))

(t/deftest amft-test []
  (t/is (= (sut/testing-tostring-amft [0 0] 4)
           "_X______X______X____X___
X_______X_______X___X___
________X________X__X__X
________X_________XXXXX_
________X_________XXXXX_
XXXXXXXXXXXXXXXXXXXX_XXX"))
  (t/is ((sut/AMFT [1 0]) [2 0])))

(t/deftest knight-capturing-thru-moat-newgame []
  (t/is (= (sut/after-of-afters {:before st/newgame :from [0 1] :to [1 23]})
           :capturing-thru-moats)))
(t/deftest nothing-to-move-there []
  (doseq [from [[2 0] [3 4] [2 23] [3 5] [5 5]]
          to [[0 0] [1 0] [1 23] [0 23] [2 1] [3 5] [2 22] [3 22] [4 5] [3 4] [5 4]]]
    (t/is (= (sut/after-of-afters {:before st/newgame :from from :to to})
             :nothing-to-move-here))))
(t/deftest can-i-move-wo-check-newgame []
  (t/is (sut/can-i-move-wo-check st/newgame :white))
  (t/is (sut/can-i-move-wo-check st/newgame :white [1 0]))
  (t/is (sut/can-i-move-wo-check st/newgame :white [1 0] #(#{{:inward (do %1 %2 true)}}) [2 0]))
  (t/is (sut/can-i-move-wo-check st/newgame :white [1 0] #(#{{:inward (do %1 %2 true)}}) [2 0] {:inward true}))
  (println (sut/after-sans-eval-death-and-check {:inward true :before st/newgame :from [1 0]}))
  )

(t/run-tests)
