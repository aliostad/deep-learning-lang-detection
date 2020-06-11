(ns interprocessing.runner
  (:require [interprocessing.csound :as csound]
            [interprocessing.genetic-algorithm :as ga]
            [interprocessing.instruments :as inst]
            [interprocessing.util :refer [iso8601-time map-seq->csv
                                          relative-diff normalize-to-unity]]))

(defn- normalize-diffs-by-range [[centroid1 cps1 rms1] [centroid2 cps2 rms2]]
  "Takes two analyses of the form [centroid cps rms] and returns their
  difference normalized by the natural ranges -- 20,000 Hz for centroid and cps,
  1.0 for rms (0 dBFS set in the Csound code)."
  ; This should probably be refactored, but it works for my purpose.
  [(/ (Math/abs (- centroid1 centroid2)) 20000)
   (/ (Math/abs (- cps1 cps2)) 20000)
   (Math/abs (- rms1 rms2))]) ; divide by one

(defn- normalize-diffs-relatively [[centroid1 cps1 rms1] [centroid2 cps2 rms2]]
  "Takes two analyses of the form [centroid cps rms], takes the relative
  difference of each pair of values and returns them as a normalized vector.

  This function has been deprecated in favor of normalize-diffs-by-range,
  but is left for documentation."
  (normalize-to-unity [(relative-diff centroid1 centroid2)
                       (relative-diff cps1 cps2)
                       (relative-diff rms1 rms2)]))

(defn create-fitness-fn
  "Takes an audio analysis of the affecting audio file of the form

    {:centroid ... :cps ... :rms ...}

  as well as a vector of weights [centroid-weight cps-weight rms-weight].
  The weights should add up to 1.

  Returns a function which takes a phenotype (an audio analysis similar
  to that of the affector) and returns a fitness value in [0, 1] inclusive,
  describing how similar the given phenotype is to the affector, with the
  importance of each characteristic weighted by the given values."
  [affector-analysis weights]
  (let [{aff-centroid :centroid aff-cps :cps aff-rms :rms} affector-analysis]
    (memoize
      (fn [phenotype]
        (let [{:keys [centroid cps rms]} phenotype
              normalized-diffs (normalize-diffs-by-range
                                 [aff-centroid aff-cps aff-rms]
                                 [centroid cps rms])
              normalized-weights (normalize-to-unity weights)
              sum (apply + (map * normalized-weights normalized-diffs))]
          (- 1 sum))))))

(defn- finalize [csound-instance run-data]
  (inst/process (:instrument run-data) csound-instance
                (:genotype (last (:history run-data)))
                (:affected run-data)
                (:audio-output run-data)))

(defn- finalize-dynamic [csound-instance run-data]
  (inst/process (:instrument run-data) csound-instance
                (:genotype (last (:analysis (first (:history run-data)))))
                (:affected run-data)
                (:audio-output run-data)
                0 ; starting point (skip-time)
                (* (:frame-size run-data) (count (:history run-data))) ; duration
                (fn [instance index]
                  (when (> (count (:history run-data)) index)
                    (let [genotype (:genotype (last
                                                (:analysis (nth (:history run-data) index))))]
                      (inst/set-fx-parameters (:instrument run-data)
                                              instance genotype))))
                (:frame-size run-data)))

(defn solve! [csound-instance affector affected instrument weights
              output-dir & {:keys [max-iterations debug?]
                            :or {max-iterations 100}}]
  (println "Starting genetic algorithm...")
  (let [timestamp (iso8601-time)
        audio-output (str output-dir "/" timestamp "-output.wav")
        affector-analysis (csound/analyze csound-instance affector)
        genotype->phenotype (inst/phenotype-fn
                              instrument csound-instance affected audio-output)
        mutate-fn #(inst/mutate-genotype instrument %)
        fitness-fn (create-fitness-fn affector-analysis weights)
        run-data {:history (ga/solve :genotype->phenotype genotype->phenotype
                                     :mutate-fn mutate-fn
                                     :fitness-fn fitness-fn
                                     :acceptable-fitness 1.0
                                     :max-iterations max-iterations
                                     :instrument instrument
                                     :debug? debug?)
                  :affector affector
                  :affected affected
                  :affector-analysis affector-analysis
                  :input-analysis (csound/analyze csound-instance affected)
                  :instrument instrument
                  :timestamp timestamp
                  :output-dir output-dir
                  :audio-output audio-output
                  :dynamic? false}]
    (finalize csound-instance run-data)
    (assoc
      run-data
      :result-analysis (csound/analyze csound-instance audio-output))))

(defn solve-dynamic! [csound-instance affector affected instrument weights
                      output-dir frame-size & {:keys [max-iterations debug?]
                                               :or {max-iterations 100}}]
  (println "Starting genetic algorithm...")
  (let [timestamp (iso8601-time)
        audio-output (str output-dir "/" timestamp "-output.wav")
        mutate-fn #(inst/mutate-genotype instrument %)
        affector-analysis (csound/analyze csound-instance affector
                                          :skip-time 0 :duration frame-size)
        genotype->phenotype (inst/phenotype-fn
                              instrument csound-instance affected audio-output
                              0 frame-size)
        fitness-fn (create-fitness-fn affector-analysis weights)
        ga-fn (partial ga/solve
                       :mutate-fn mutate-fn
                       :acceptable-fitness 1.0
                       :max-iterations max-iterations
                       :instrument instrument
                       :debug? debug?)
        first-frame {:analysis (ga-fn :genotype->phenotype genotype->phenotype
                                      :fitness-fn fitness-fn)
                     :frame 1
                     :skip-time 0}]
    (loop [frames [first-frame]
           frame 2
           skip-time frame-size
           affector-analysis affector-analysis
           genotype->phenotype genotype->phenotype
           fitness-fn fitness-fn]
      (if (not= (csound/get-channel-value csound-instance "abort") 0.0)
        (let [run-data {:history frames
                        :affector affector
                        :affected affected
                        :affector-analysis (csound/analyze csound-instance affector)
                        :input-analysis (csound/analyze csound-instance affected)
                        :instrument instrument
                        :frame-size frame-size
                        :timestamp timestamp
                        :output-dir output-dir
                        :audio-output audio-output
                        :dynamic? true}]
          (csound/set-channel-value csound-instance "abort" 0.0)
          (finalize-dynamic csound-instance run-data)
          (assoc
            run-data
            :result-analysis (csound/analyze csound-instance audio-output)))
        (let [skip-time (+ skip-time frame-size)
              affector-analysis (csound/analyze csound-instance affector
                                                :skip-time skip-time
                                                :duration frame-size)
              genotype->phenotype (inst/phenotype-fn instrument csound-instance
                                                     affected audio-output
                                                     skip-time frame-size)
              fitness-fn (create-fitness-fn affector-analysis weights)]
          (recur
            (conj frames {:analysis (ga-fn :genotype->phenotype genotype->phenotype
                                           :fitness-fn fitness-fn)
                          :frame frame
                          :skip-time skip-time})
            (inc frame) skip-time
            affector-analysis genotype->phenotype fitness-fn))))))

(defn- flatten-history [history]
  (map (fn [row]
         (merge (dissoc row :phenotype :fx-params)
                (:phenotype row)
                (:fx-params row)))
       history))

(defn- flatten-dynamic-history [history]
  (flatten
    (for [frame history]
      (map #(assoc % :frame (:frame frame))
           (flatten-history (:analysis frame))))))

(defn log! [run-data]
  (let [prefix (str (:output-dir run-data) "/" (:timestamp run-data))
        affector-analysis-output (str prefix "-affector-analysis.csv")
        input-analysis-output (str prefix "-input-analysis.csv")
        dynamic-history-output (str prefix "-dynamic-history.csv")
        history-output (str prefix "-history.csv")
        result-analysis-output (str prefix "-result-analysis.csv")]
    (spit affector-analysis-output (map-seq->csv
                                     [(:affector-analysis run-data)]))
    (println (str "Wrote affector analysis to " affector-analysis-output))
    (spit input-analysis-output (map-seq->csv
                                  [(:input-analysis run-data)]))
    (println (str "Wrote input analysis to " input-analysis-output))
    (if (:dynamic? run-data)
      (do
        (spit dynamic-history-output
              (map-seq->csv (flatten-dynamic-history (:history run-data))))
        (println (str "Wrote run history to " dynamic-history-output)))
      (do
        (spit history-output
              (map-seq->csv (flatten-history (:history run-data))))
        (println (str "Wrote run history to " history-output))))
    (spit result-analysis-output (map-seq->csv [(:result-analysis run-data)]))
    (println (str "Wrote result analysis to " result-analysis-output))))
