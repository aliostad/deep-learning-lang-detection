;the sense in making a file for each instrument is that people can include them in their own namespaces individually, which can be costly
;because the buffers are large.
(ns ^{ :author "Alex Seewald" }
  philharmonia-samples.sampled-trombone
  (:use [philharmonia-samples.sample-utils]
        [overtone.live]))

(def trombone-samples (path-to-described-samples (str sampleroot "/trombone")))
(def defaults (array-map :note "52" :duration "025" :loudness "forte" :style "normal"))
(def features (featureset [:note :duration :loudness :style] (keys trombone-samples)))
(def distance-maxes {:note 1 :duration 4 :loudness 3 :style 6})

(def ^:private tmp (play-gen trombone-samples defaults features distance-maxes))
(def trombone (:ugen tmp))
(def trombone-inst (:effect tmp))
(def trombonei (:effect tmp))
