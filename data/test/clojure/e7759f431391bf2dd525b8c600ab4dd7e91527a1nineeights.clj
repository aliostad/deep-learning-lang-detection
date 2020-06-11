;; nineeights.clj
;; (c) 2017 by Milan Gruner
;; Part of project "AlgorithMuss"

(ns algorithmuss.nineeights)
(use 'algorithmuss.instruments)

(require
	'[leipzig.melody :refer [all bpm is phrase tempo then times where with]]
	'[overtone.live :as overtone]
	'[leipzig.live :as live]
	'[leipzig.scale :as scale])

(def melody (phrase
	[1/8	3/8	1/8	2/8	1/8	1/8	1/8]
	[0	0	2	1	4	3	1]))

(def main-instrument funky)

(defmethod live/play-note :default [{midi :pitch seconds :duration}]
	(-> midi overtone/midi->hz (main-instrument seconds)))

(->>
	melody
	(tempo (bpm 90))
	(where :pitch (comp scale/C scale/major))
	live/play)
