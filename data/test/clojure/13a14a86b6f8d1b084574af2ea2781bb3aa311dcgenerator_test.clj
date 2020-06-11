(ns clj-meetup-spec-talk.generator-test
  (:require [clojure.spec :as s]
            [clojure.spec.gen :as gen]
            [clojure.spec.test :as stest]
            [clojure.pprint :refer [pprint]]
            [clj-meetup-spec-talk.instrument :as i :refer :all]))

;; examples from http://clojure.org/guides/spec

(gen/generate (s/gen int?))

(gen/generate (s/gen nil?))

(comment

  (gen/sample (s/gen string?))

  (gen/sample (s/gen #{:club :diamond :heart :spade}))

  (pprint (gen/sample (s/gen (s/cat :k keyword? :ns (s/+ number?)))))

  (pprint (gen/generate (s/gen ::i/player)))

  (pprint (gen/generate (s/gen ::i/game)))
  )

(stest/check-var #'i/ranged-rand)
