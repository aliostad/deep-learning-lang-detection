;the sense in making a file for each instrument is that people can include them in their own namespaces individually, which can be costly
;because the buffers are large.
(ns ^{ :author "Alex Seewald" }
  philharmonia-samples.sampled-violin
  (:use [philharmonia-samples.sample-utils]
        [overtone.live]))

(def violin-samples (path-to-described-samples (str sampleroot "/violin")))
(def defaults (array-map :note "60" :duration "025" :loudness "forte" :style "arco-normal"))
(def features (featureset [:note :duration :loudness :style] (keys violin-samples)))
(def distance-maxes {:note 1 :duration 4 :loudness 3 :style 6})

(def ^:private tmp (play-gen violin-samples defaults features distance-maxes))
(def violin (:ugen tmp))
(def violin-inst (:effect tmp))
(def violini (:effect tmp))
