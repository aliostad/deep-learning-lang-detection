(ns spede.destructure-keys-test
  (:require  [clojure.test :as t]
             [spede.core :as es]
             [clojure.spec :as s]
             [clojure.spec.test :as st]
             [spede.args.map :as map]
             [spede.test-utils :as tu])
  (:import clojure.lang.ExceptionInfo))

(s/def ::a integer?)

(es/sdefn some-func [{:keys [::a ::b ::c]}]
  (+ a b c))

(st/instrument `some-func)

(t/deftest spec-gen
  (let [spec (->> (tu/get-spec-of-first-arg `some-func)
                  (drop 1)
                  (apply hash-map))]
    (t/is (= #{::a ::b ::c} (->> spec
                                 :req
                                 (apply hash-set))))))

(es/sdefn func-with-keys [{c ::c :keys [:a b ::d]}]
          (println "ugh"))

(t/deftest spec-gen-un
  (let [spec (->> (-> (s/get-spec `func-with-keys)
                      s/form
                      (nth 2)
                      (nth 2))
                  (drop 1)
                  (apply hash-map))]
    (t/is (= #{::c ::d} (->> spec
                             :req
                             (apply hash-set))))
    (t/is (= #{::a ::b} (->> spec
                             :req-un
                             (apply hash-set))))))

(t/deftest test-keys-gen
  (t/is (= 6 (some-func {::a 1 ::b 2 ::c 3})))
  (t/is (thrown-with-msg? ExceptionInfo #"did not conform to spec"
                          (some-func {::a "ugh" ::b 2 ::c 3}))))

