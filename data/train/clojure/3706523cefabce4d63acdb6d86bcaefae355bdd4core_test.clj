(ns defjoke.core-test
  (:require [clojure.test :refer :all]
            [clojure.spec.alpha :as spec]
            [clojure.spec.test.alpha :as spec-test]
            [defjoke.joke-specs :refer :all]))

(spec-test/instrument `tell-story)
(deftest testing-stories

  (let [riddle     {:defjoke/story        :defjoke/riddle
                    :defjoke/riddle-poser "42"}
        dialogue   {:defjoke/story :defjoke/dialogue
                    :dialogue      ["X" "Y" "Z" "@"]}
        shaggy-dog {:defjoke/story :defjoke/shaggy-dog
                    :shaggy-dog    "a longer story"}]

    (testing "telling stories"

      (is (spec/conform :defjoke/riddle riddle))
      (is (spec/conform tell-story riddle))

      (is (spec/conform :defjoke/dialogue dialogue))
      (is (spec/conform tell-story dialogue))

      (is (spec/conform :defjoke/shaggy-dog shaggy-dog))
      (is (spec/conform tell-story shaggy-dog)))))

(spec-test/unstrument `tell-story)
(deftest testing-story-exceptions
  (testing "failed stories"
    (is (thrown-with-msg?
          IllegalArgumentException
          #"No method in multimethod 'tell-story' for dispatch value: :defjoke/unknown"
          (spec/conform tell-story {:defjoke/story :defjoke/unknown
                                    :shaggy-dog    "a longer story"})))))

(spec-test/instrument `zing)
(deftest testing-zingers

  (let [zinger {:defjoke/punch-line :defjoke/zinger
                :defjoke/zing       "One liner"}]

    (testing "zinging"
      (is (spec/conform :defjoke/zinger zinger))
      (is (spec/conform zing zinger)))))

(spec-test/unstrument `zing)
(deftest testing-zing-exceptions
  (testing "failed zings"
    (is (thrown-with-msg?
          IllegalArgumentException
          #"No method in multimethod 'zing' for dispatch value: :defjoke/unknown"
          (spec/conform zing {:defjoke/punch-line :defjoke/unknown
                              :defjoke/zing       "boom!"})))))
