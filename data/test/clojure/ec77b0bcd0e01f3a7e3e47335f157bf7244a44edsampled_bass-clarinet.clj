;the sense in making a file for each instrument is that people can include them in their own namespaces individually, which can be costly
;because the buffers are large.
(ns ^{ :author "Alex Seewald" }
  philharmonia-samples.sampled-bass-clarinet
  (:use [philharmonia-samples.sample-utils]
        [overtone.live]))

(def bass-clarinet-samples (path-to-described-samples (str sampleroot "/bass-clarinet")))
(def defaults (array-map :note "60" :duration "025" :loudness "forte" :style "normal"))
(def features (featureset [:note :duration :loudness :style] (keys bass-clarinet-samples)))
(def distance-maxes {:note 1 :duration 4 :loudness 3 :style 6})

(def ^:private tmp (play-gen bass-clarinet-samples defaults features distance-maxes))
(def bass-clarinet (:ugen tmp))
(def bass-clarinet-inst (:effect tmp))
(def bass-clarineti (:effect tmp))
