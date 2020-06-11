(ns org.wol.kraken-client.audio
  (:require [wol-utils.core   :as wol-utils])
  (:use
   [clj-etl-utils.lang-utils :only [raise]])
  (:import [javax.sound.sampled DataLine AudioSystem Clip DataLine$Info
            FloatControl$Type BooleanControl$Type]))


(def *Drum1* (atom nil))
(def *Drum2* (atom nil))
(def *Drum3* (atom nil))
(def *Drum4* (atom nil))

(def *default-instruments*
     [ {:instrument *Drum1* :file "sounds/tonebell01.aif"}
       {:instrument *Drum2* :file "sounds/clickthump1.wav"}
       {:instrument *Drum3* :file "sounds/blue.wav"}
       {:instrument *Drum4* :file "sounds/click2.wav"} ])

(def *max-volume* 13.9794)
(def *min-volume* -40)


(defn get-volume-control [instrument]
  (first (filter (fn [c] (= FloatControl$Type/MASTER_GAIN (.getType c)))
                 (.getControls @instrument))))

(defn volume-change [{instr-num :instrument new-volume :value}]
  (def *chicken* instr-num)
  (def *tuna* new-volume)
  (let [instr (:instrument (nth *default-instruments* instr-num))
        vol-control (get-volume-control instr)
        new-value   (+ (* (/ new-volume 100)
                          (- *max-volume* *min-volume*))
                       *min-volume*)]
    (wol-utils/wol-info "Setting volume for instrument %s to %f" instr-num new-value)
    (.setValue vol-control new-value )))

(comment
  (.getValue (get-volume-control (:instrument (first *default-instruments*))))2G
  (.setValue (get-volume-control (:instrument (first *default-instruments*))))
  *tuna*
  (class *tuna*)
  *chicken*
  (class *chicken*)
  )


(defn get-mute-control [instrument]
  (first (filter (fn [c] (= BooleanControl$Type/MUTE (.getType c)))
               (.getControls @instrument))))

(defn load-sound-from-url [instrument audio-url]
  (wol-utils/wol-info "Loading sound(%s) into instrument(%s)"
                      audio-url instrument)
  (let [ain (AudioSystem/getAudioInputStream audio-url)]
   (try
    (let [line-info (DataLine$Info. Clip (.getFormat ain))
          clip (AudioSystem/getLine line-info)]
      (reset! instrument clip)
      (.open @instrument ain))
    (finally
     (.close ain)))))



(defn clear-sounds []
  (wol-utils/wol-info "Clearing sounds")
  (doseq [{instr :instrument file :file} *default-instruments* ]
    (reset! instr nil)))

(defn load-default-sounds []
  (doseq [{instr :instrument file :file} *default-instruments* ]
    (let [audio-url (wol-utils/obtain-resource-url
                     *ns*
                     file)]
      (load-sound-from-url instr audio-url)
      (.setValue (get-volume-control instr) *max-volume*))))

(defn play-sound-from-atom [snd-atom]
  (.stop @snd-atom)
  (.setMicrosecondPosition @snd-atom 0)
  (.start @snd-atom))

(comment
  (load-default-sounds)

  )