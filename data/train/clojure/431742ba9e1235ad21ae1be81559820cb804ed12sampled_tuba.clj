;the sense in making a file for each instrument is that people can include them in their own namespaces individually, which can be costly
;because the buffers are large.
(ns ^{ :author "Alex Seewald" }
  philharmonia-samples.sampled-tuba
  (:use [philharmonia-samples.sample-utils]
        [overtone.live]))

(def tuba-samples (path-to-described-samples (str sampleroot "/tuba")))
(def defaults (array-map :note "52" :duration "025" :loudness "forte" :style "normal"))
(def features (featureset [:note :duration :loudness :style] (keys tuba-samples)))
(def distance-maxes {:note 1 :duration 4 :loudness 3 :style 6})


(def ^:private tmp (play-gen tuba-samples defaults features distance-maxes))
(def tuba (:ugen tmp))
(def tuba-inst (:effect tmp))
(def tubai (:effect tmp))
