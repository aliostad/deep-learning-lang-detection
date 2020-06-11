;the sense in making a file for each instrument is that people can include them in their own namespaces individually, which can be costly
;because the buffers are large.
(ns ^{ :author "Alex Seewald" }
  philharmonia-samples.sampled-oboe
  (:use [philharmonia-samples.sample-utils]
        [overtone.live]))

(def oboe-samples (path-to-described-samples (str sampleroot "/oboe")))
(def defaults (array-map :note "63" :duration "025" :loudness "forte" :style "normal"))
(def features (featureset [:note :duration :loudness :style] (keys oboe-samples)))
(def distance-maxes {:note 1 :duration 4 :loudness 3 :style 6})

(def ^:private tmp (play-gen oboe-samples defaults features distance-maxes))
(def oboe (:ugen tmp))
(def oboe-inst (:effect tmp))
(def oboei (:effect tmp))
