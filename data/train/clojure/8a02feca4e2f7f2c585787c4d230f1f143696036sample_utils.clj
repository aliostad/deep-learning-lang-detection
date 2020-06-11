(ns
    ^{:doc "The (minimal) infrastructure needed for overtone-readiness of samples"
      :author "Alex Seewald" }
 philharmonia-samples.sample-utils
  (:use   [overtone.live])
  (:require [clojure.string :as string]
            [clojure.java.io :as io]
            [clj-diff.core :as diff]
            [clojure.core.matrix :as matrix]))

(def sampleroot "resources/phil-samples")
(defn path-to-described-samples
  "Takes a path pointing to a directory which is expected to contain a subdirectory for each wanted sampled instrument. The directory for each instrument is expected to have sound files of .wav format, and the names of these files are supposed to consist of the instrument name followed by underscore-separated features associated with the sample.

  Produces a map where the keys are the identifying features of the sample, and the values are the samples themselves (not directly callable samples, because they are made with load-sample)"
  [path]
  (let [relevant-fnames (filter (fn [fname] (-> (re-matches #".*.wav" fname) nil? not))
                                (map str (rest (file-seq (io/file path)))))
        feature-names (for [fname relevant-fnames]
                        (rest (map #(first (string/split % #".wav"))
                               (string/split fname #"_"))))]
    (zipmap feature-names (map load-sample relevant-fnames))))

(defn featureset
  "Takes a list of names associated with the features and a list of allowed values associated with those names.
   Produces a map of those associations; this is done to eliminate redundencies. "
  [featurenames featurevals]
  (zipmap featurenames (map (comp vec set) (matrix/transpose featurevals))))

; the notion of correct-values? can be removed by making max distance 0.  the notion of modifyable-features
; can be removed by

(defn try-corrected-val
  "This gets mapped over key-value pairs provided by the user. "
  [featurename featureval defaults featureset distance-maxes ]
  (let [featureval (if (= featurename :note)
                     (if (integer? featureval)
                         (str featureval)
                         (-> featureval note str))
                     featureval)
        ds (for [allowed-valuename (get featureset featurename)]
             {:n allowed-valuename :d (diff/edit-distance featureval allowed-valuename)})
        minimum (first (sort-by :d ds))]
    (if (some #(= featureval %) (get featureset featurename)) ;the featureval is valid.
      featureval
      (if (and (string? featureval) (<= (:d minimum) (get distance-maxes featurename)))
        (do
          (println (format "corrected featurename %s from value %s to value %s" featurename featureval (:n minimum)))
          (:n minimum))
        (do
          (println (format "not going to correct featurename %s which has value %s, trying default value %s" featurename featureval (get defaults featurename)))
          (get defaults featurename))))))


(defn play-gen
  "A closure that produces a function that maps instrument features to ugens."
  [described-inst defaults feature-set distance-maxes]
  (let [feature-names (keys defaults)
        inst-defaults (vals defaults)
        map-handle (fn [the-map distance-maxes] (for [[feature-name default-value] defaults] ;the order here enforces proper ordering.
                                                 (if (contains? the-map feature-name) ;since this handling is here, it might make sense to refactor
                                                     (try-corrected-val feature-name (get the-map feature-name) defaults feature-set distance-maxes)
                                                     default-value)))
        num-channels 1 ;this is information *about* the samples that the sampling process must know about.
        descr (fn [args]
                (cond
                 (empty? args) inst-defaults
                 (integer? (first args)) (map-handle {:note (first args)} distance-maxes)
                 (vector? (first args)) (first args)
                 (map? (first args)) (map-handle (first args) distance-maxes)
                 true (map-handle (apply hash-map args) distance-maxes)))]
    {:ugen
     (fn [& args]
      (let [choice (descr args)]
        (if (contains? described-inst choice)
            (play-buf num-channels (get described-inst choice))
            (do (println (format "%s that sample is not available" (str (vec choice))))
                false))))
     :effect
(fn [& args]
      (let [choice (descr args)]
        (if (contains? described-inst choice)
            (do
              (demo (play-buf num-channels (get described-inst choice)))
              true)
            (do (println (format "%s that sample is not available" (str (vec choice))))
                false))))
     }))
