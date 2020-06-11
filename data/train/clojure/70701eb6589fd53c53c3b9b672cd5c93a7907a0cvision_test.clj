(ns burningswell.worker.vision-test
  (:require [burningswell.worker.vision :refer :all]
            [clojure.spec.test.alpha :refer [instrument]]
            [clojure.test :refer :all]))

(use-fixtures :once (fn [f] (instrument) (f)))

(deftest test-landmark-detection
  (let [image "test-resources/images/bad/eiffel-tower.jpg"
        annotations (annotate-image (service) image {:landmarks 5})
        landmark (-> annotations :landmarks first)]
    (is (= (count (:landmarks annotations)) 1))
    (is (= (:description landmark) "Eiffel Tower"))
    (is (= (:mid landmark) "/m/02j81"))
    (is (= (:locations landmark)
           [{"latLng" {"latitude" 48.858461
                       "longitude" 2.294351}}]))
    (is (<= 0.0 (:score landmark) 1.0))))

(deftest test-label-beach
  (let [image "test-resources/images/good/beach.png"
        annotations (annotate-image (service) image {:labels 5})]
    (is (= (map #(select-keys %1 [:description :mid])
                (:labels annotations))
           [{:description "coast", :mid "/m/01lxd"}
            {:description "beach", :mid "/m/0b3yr"}
            {:description "body of water", :mid "/m/03ktm1"}
            {:description "shore", :mid "/m/02fm9k"}
            {:description "caribbean", :mid "/m/0261m"}]))
    (is (apply >= (map :score (-> annotations :labels))))))

(deftest test-label-surfer-enters-water
  (let [image "test-resources/images/good/surfer-enters-water.png"
        annotations (annotate-image (service) image {:labels 5})]
    (is (= (map #(select-keys %1 [:description :mid])
                (:labels annotations))
           [{:description "wind wave", :mid "/m/034srq"}
            {:description "water sport", :mid "/m/02fhdf"}
            {:description "sports", :mid "/m/06ntj"}
            {:description "surfing", :mid "/m/06_g7"}
            {:description "boardsport", :mid "/m/09qkx"}]))
    (is (apply >= (map :score (-> annotations :labels))))))
