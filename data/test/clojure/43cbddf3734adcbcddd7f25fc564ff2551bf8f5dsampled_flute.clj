;the sense in making a file for each instrument is that people can include them in their own namespaces individually, which can be costly
;because the buffers are large.
(ns ^{ :author "Alex Seewald" }
  philharmonia-samples.sampled-flute
  (:use [philharmonia-samples.sample-utils]
        [overtone.live]))

(def flute-samples (path-to-described-samples (str sampleroot "/flute")))
(def defaults (array-map :note "65" :duration "025" :loudness "forte" :style "normal"))
(def features (featureset [:note :duration :loudness :style] (keys flute-samples)))
(def distance-maxes {:note 1 :duration 4 :loudness 3 :style 6})

(def ^:private tmp (play-gen flute-samples defaults features distance-maxes))
(def flute (:ugen tmp))
(def flute-inst (:effect tmp))
(def flutei (:effect tmp))
