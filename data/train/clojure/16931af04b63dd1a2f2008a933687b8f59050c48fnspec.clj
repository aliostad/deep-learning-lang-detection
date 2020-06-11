(ns spectalk.fnspec
  (:require [clojure.spec :as s]
            [clojure.spec.gen :as gen]
            [clojure.spec.test :as stest]
            [spectalk.utils :as u]))









;; Same as we saw:
(s/fdef ranged-rand
        :args (s/and (s/cat :start int? :end int?)
                     #(< (:start %) (:end %)))
        :ret int?
        :fn (s/and #(>= (:ret %) (-> % :args :start))
                   #(< (:ret %) (-> % :args :end))))





;; Define a function
(defn ranged-rand
  "Returns random int in range start <= rand < end"
  [start end]
  (+ start (long (rand (- end start)))))








;; Spec the function
(s/fdef ranged-rand
        :args (s/and (s/cat :start int? :end int?)))







;; Instrument
(stest/instrument `ranged-rand)







(ranged-rand 3 5)

(ranged-rand 8 :dog)







;; But you can still pass problematic args:
(ranged-rand 5 3)

;; Add a condition
(s/fdef ranged-rand
        :args (s/and (s/cat :start int? :end int?)
                     #(< (:start %) (:end %))))

(stest/instrument `ranged-rand)

(ranged-rand 5 3)






(stest/check `ranged-rand)
