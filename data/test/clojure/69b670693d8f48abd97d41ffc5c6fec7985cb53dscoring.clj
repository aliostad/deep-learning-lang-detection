;
; This file is part of darwin.
;
; Copyright (C) 2014-, Imperial College, London, All rights reserved.
;
; Contributors: Jony Hudson
;
; Released under the MIT license..
;

(ns darwin.evolution.scoring
  "Functions in this namespace manage the process of scoring individuals in a population.
  The actual score functions themselves are representation dependent and will be found with
  the implementations of the representations.")

(defn update-individual-scores
  "Update the scores for an individual. The score functions are given as a map of functions:
  each function will be applied to the individual's genotype and its result stored on the individual,
  under the function's key."
  [score-funcs individual]
  (merge individual
         (into {} (map (fn [s] [(first s) ((second s) (:genotype individual))]) score-funcs))))

(defn update-scores
  "Update the scores for each individual in the given list. See above for how the score functions are
   specified."
  [individuals score-funcs]
  (doall (pmap (partial update-individual-scores score-funcs) individuals)))