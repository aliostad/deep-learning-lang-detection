(ns western-music.lib.ui.monad-test
  (:require [clojure.test :refer [deftest is testing run-tests]]
            [western-music.lib.ui.monad :as m]))

(def ^:const db {:name "foo"})

(def ^:const effects
  {:db db
   :dispatch [:new-foo]
   :dispatch-n [[:hello] [:world]]})

(defn transform [db new-name]
  {:db (assoc db :name new-name)
   :dispatch [:new-name new-name]
   :dispatch-later [{:ms 1000 :dispatch [:some-stuff new-name]}]})

(deftest test-fx=
  (is (m/fx= effects
             {:db db
              :dispatch-n [[:hello] [:world] [:new-foo]]}
             {:db db
              :dispatch [:world]
              :dispatch-n [[:hello] [:new-foo]]}
             {:db db
              :dispatch-n [[:new-foo] [:hello] [:world]]})))

(deftest test-monad-laws
  (is (m/fx= (m/bind (m/return db) transform "hello")
           (transform db "hello"))
      "left identity")
  (is (m/fx= (m/bind effects m/return) effects) "right identity")
  (is (m/fx= (-> effects
               (m/bind transform "hello")
               (m/bind transform "world"))
           (m/bind effects
                   #(-> %
                        (transform "hello")
                        (m/bind transform "world"))))
      "associativity"))
