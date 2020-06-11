;the sense in making a file for each instrument is that people can include them in their own namespaces individually, which can be costly
;because the buffers are large.
(ns ^{ :author "Alex Seewald" }
  philharmonia-samples.sampled-viola
  (:use [philharmonia-samples.sample-utils]
        [overtone.live]))

(def viola-samples (path-to-described-samples (str sampleroot "/viola")))
(def defaults (array-map :note "67" :duration "025" :loudness "fortissimo" :style "arco-normal"))
(def features (featureset [:note :duration :loudness :style] (keys viola-samples)))
(def distance-maxes {:note 1 :duration 4 :loudness 3 :style 6})


(def ^:private tmp (play-gen viola-samples defaults features distance-maxes))
(def viola (:ugen tmp))
(def viola-inst (:effect tmp))
(def violai (:effect tmp))
