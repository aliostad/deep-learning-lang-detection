

(require '[clojure.spec :as s])
(require '[clojure.spec.gen :as gen])
(require '[clojure.spec.test :as stest])

(defn ranged-rand
    "Retorna un entero random entre el inicio y el fin donde
    inicio <= random < fin"
      [inicio fin]
        (long (rand (- fin inicio))))

(s/fdef ranged-rand
  :args (s/and (s/cat :inicio int? :fin int?)
               (fn ini-menor-fin [a] (< (:inicio a) (:fin a))))
  :ret int?
  :fn (s/and (fn mayori-al-inicio [e] (>= (:ret e) (-> e :args :inicio)))
             (fn menor-al-fin [e] (< (:ret e) (-> e :args :fin)))))

(stest/instrument `ranged-rand)
(ranged-rand 10 5)
(ranged-rand 10 20)

(s/exercise-fn `ranged-rand)

(stest/summarize-results (stest/check `ranged-rand))


