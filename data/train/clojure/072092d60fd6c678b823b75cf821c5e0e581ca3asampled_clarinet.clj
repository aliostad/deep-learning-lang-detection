;the sense in making a file for each instrument is that people can include them in their own namespaces individually, which can be costly
;because the buffers are large.
(ns ^{ :author "Alex Seewald" }
  philharmonia-samples.sampled-clarinet
  (:use [philharmonia-samples.sample-utils]
        [overtone.live]))

(def clarinet-samples (path-to-described-samples (str sampleroot "/clarinet")))
(def defaults (array-map :note "60" :duration "15" :loudness "forte" :style "normal"))
(def features (featureset [:note :duration :loudness :style] (keys clarinet-samples)))
(def distance-maxes {:note 1 :duration 4 :loudness 3 :style 6})

(def ^:private tmp (play-gen clarinet-samples defaults features distance-maxes))
(def clarinet (:ugen tmp))
(def clarinet-inst (:effect tmp))
(def clarineti (:effect tmp))
