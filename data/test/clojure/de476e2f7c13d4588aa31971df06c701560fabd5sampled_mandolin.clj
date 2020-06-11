;the sense in making a file for each instrument is that people can include them in their own namespaces individually, which can be costly
;because the buffers are large.
(ns ^{ :author "Alex Seewald" }
  philharmonia-samples.sampled-mandolin
  (:use [philharmonia-samples.sample-utils]
        [overtone.live]))

(def mandolin-samples (path-to-described-samples (str sampleroot "/mandolin")))
(def defaults (array-map :note "65" :duration "very-long" :loudness "piano" :style "normal"))
(def features (featureset [:note :duration :loudness :style] (keys mandolin-samples)))
(def distance-maxes {:note 1 :duration 4 :loudness 3 :style 6})

(def ^:private tmp (play-gen mandolin-samples defaults features distance-maxes))
(def mandolin (:ugen tmp))
(def mandolin-inst (:effect tmp))
(def mandolini (:effect tmp))
