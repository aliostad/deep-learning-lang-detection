(ns hara.function.dispatch-test
  (:use hara.test)
  (:require [hara.function.dispatch :refer :all]))

^{:refer hara.function.dispatch/call :added "2.1"}
(fact "Executes `(f v1 ... vn)` if `f` is not nil"

  (call nil 1 2 3) => nil

  (call + 1 2 3) => 6)

^{:refer hara.function.dispatch/msg :added "2.1"}
(fact "Message dispatch for object orientated type calling convention."

  (def obj {:a 10
            :b 20
            :get-sum (fn [this]
                      (+ (:b this) (:a this)))})

  (msg obj :get-sum) => 30)
