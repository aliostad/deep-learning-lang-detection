;the sense in making a file for each instrument is that people can include them in their own namespaces individually, which can be costly
;because the buffers are large.
(ns ^{ :author "Alex Seewald" }
  philharmonia-samples.sampled-banjo
  (:use [philharmonia-samples.sample-utils]
        [overtone.live]))

(def banjo-samples (path-to-described-samples (str sampleroot "/banjo")))
;Note, these defaults are considered 'post-processed'. The main effect of that is that the note must be of string type and indicate a midi note; there
;is not the integer/string flexibility here.
(def defaults (array-map :note "60" :duration "very-long" :loudness "forte" :style "normal"))
(def features (featureset [:note :duration :loudness :style] (keys banjo-samples)))
(def distance-maxes {:note 1 :duration 4 :loudness 3 :style 6})

(def ^:private tmp (play-gen banjo-samples defaults features distance-maxes))
(def banjo (:ugen tmp))
(def banjo-inst (:effect tmp))
(def banjoi (:effect tmp))
