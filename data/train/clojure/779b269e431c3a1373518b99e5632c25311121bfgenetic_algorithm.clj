(ns interprocessing.genetic-algorithm
  (:require [clojure.core.matrix :as m]
            [clojure.core.matrix.stats :as stats]
            [clojure.string :as str]
            [interprocessing.bits :refer :all]
            [interprocessing.instruments :as inst]
            [interprocessing.util :refer [relative-diff]]))

(defn new-genotype
  "Returns a random 64-bit long representing a genotype bit string."
  [] (rand-long))

(defn genotype->string [genotype]
  (let [parts (long->quadruple genotype)
        strings (map #(to-binary-string % :min-length 16) parts)]
    (str/join " " strings)))

(defn generate-offspring
  "Generates the given number of mutations of the parent genotype and evaluates
  the offspring's phenotype and fitness values. Returns a sequence of maps
  containing the genotype, fitness, the FX parameters resulting from the
  genotype and the means of the analyzed features (centroid, CPS and RMS) for
  each individual."
  [parent-genotype number genotype->phenotype mutate-fn fitness-fn instrument]
  (for [_ (range number)
        :let [genotype (mutate-fn parent-genotype)
              phenotype (genotype->phenotype genotype)
              fx-params (inst/genotype->fx-parameters instrument genotype)
              fitness (fitness-fn phenotype)]]
    {:genotype genotype :fitness fitness
     :phenotype phenotype :fx-params fx-params}))

(defn stagnated?
  "Given a sequence of solutions of the form {:fitness 0.745 ...}, determines
  whether the the last max-iterations pairs of solutions' (absolute) fitness
  values were within the epsilon of each other. In other words, the
  function determines whether the history of solutions has stopped changing
  significantly. If so, the evolution is considered stagnant and the return
  value is true, otherwise it is false."
  [history & {:keys [epsilon max-iterations]
              :or {epsilon 1E-9 max-iterations 1000}}]
  (if (> (count history) max-iterations)
    (let [pairs (partition 2 1 (take-last max-iterations history))
          diffs (map #(apply relative-diff %)
                     (for [pair pairs] (map :fitness pair)))]
      (every? #(< % epsilon) diffs))
    false))

(defn solve [& {:keys [genotype->phenotype mutate-fn fitness-fn
                       acceptable-fitness max-iterations instrument debug?]
                :or {max-iterations 100 debug? false}}]
  (let [init-genotype (new-genotype)
        init-fx-params (inst/genotype->fx-parameters instrument init-genotype)
        init-phenotype (genotype->phenotype init-genotype)
        init-fitness (fitness-fn init-phenotype)
        epsilon 1E-18]

    (when debug?
      (println init-fitness))

    (loop [generation 2
           parent-genotype init-genotype
           parent-fitness init-fitness
           history [{:generation 1
                     :genotype init-genotype
                     :phenotype init-phenotype
                     :fitness init-fitness
                     :fx-params init-fx-params}]
           offspring (generate-offspring parent-genotype 4 genotype->phenotype
                                         mutate-fn fitness-fn instrument)]
      (if (or (>= parent-fitness acceptable-fitness)
              (stagnated? history
                          :epsilon epsilon
                          :max-iterations max-iterations))
        history
        (let [best-child (apply max-key :fitness offspring)]
          (when debug?
            (println parent-fitness))
          (if (>= (:fitness best-child) parent-fitness)
            (recur (inc generation)
                   (:genotype best-child)
                   (:fitness best-child)
                   (conj history (assoc best-child :generation generation))
                   (generate-offspring (:genotype best-child) 4
                                       genotype->phenotype mutate-fn
                                       fitness-fn instrument))
            (recur (inc generation)
                   parent-genotype
                   parent-fitness
                   (conj history (update (last history) :generation inc))
                   (generate-offspring parent-genotype 4 genotype->phenotype
                                       mutate-fn fitness-fn instrument))))))))
