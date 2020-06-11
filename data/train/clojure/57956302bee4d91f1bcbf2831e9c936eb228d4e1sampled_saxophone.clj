;the sense in making a file for each instrument is that people can include them in their own namespaces individually, which can be costly
;because the buffers are large.
(ns ^{ :author "Alex Seewald" }
  philharmonia-samples.sampled-saxophone
  (:use [philharmonia-samples.sample-utils]
        [overtone.live]))

(def saxophone-samples (path-to-described-samples (str sampleroot "/saxophone")))
(def defaults (array-map :note "64" :duration "025" :loudness "forte" :style "normal"))
(def features (featureset [:note :duration :loudness :style] (keys saxophone-samples)))
(def distance-maxes {:note 1 :duration 4 :loudness 3 :style 6})

(def ^:private tmp (play-gen saxophone-samples defaults features distance-maxes))
(def saxophone (:ugen tmp))
(def saxophone-inst (:effect tmp))
(def saxophonei (:effect tmp))
