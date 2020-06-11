(ns dungeonstrike.gui-test
  (:require [dungeonstrike.gui :as gui]
            [clojure.test :as test :refer [deftest is]]
            [effects.core :as effects]
            [orchestra.spec.test :as orchestra]
            [dungeonstrike.dev :as dev]))
(orchestra/instrument)
(dev/require-dev-helpers)

(deftest message-selected
  (is (= [(effects/effect :dungeonstrike.gui/config
                          :selector :#message-form
                          :key :selected
                          :value :m/load-scene
                          :persistent? true)]
         (effects/evaluate'
          (effects/request :r/message-selected
                           :m/message-type :m/load-scene)))))
