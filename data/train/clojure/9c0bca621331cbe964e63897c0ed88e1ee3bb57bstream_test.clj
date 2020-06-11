(ns jiksnu.modules.core.model.stream-test
  (:require [clj-factory.core :refer [factory]]
            [jiksnu.mock :as mock]
            [jiksnu.modules.core.model.stream :as model.stream]
            [jiksnu.test-helper :as th]
            [midje.sweet :refer :all]
            [validateur.validation :refer [valid?]]))

(th/module-test ["jiksnu.modules.core"])

(fact "#'model.stream/count-records"

  (fact "when there aren't any items"
    (model.stream/drop!)
    (model.stream/count-records) => 0)

  (fact "when there are items"
    (model.stream/drop!)
    (let [user (mock/a-user-exists)]
      (let [n 15]
        (dotimes [i n]
          (mock/a-stream-exists {:user user}))

        ;; Creating a user adds 2 streams
        (model.stream/count-records) => (+ n 2)))))
