(ns org.wol.minotaur.audio
  (:require [wol-utils.core :as wol-utils])
  (:import [javax.sound.sampled DataLine AudioSystem Clip DataLine$Info]))


(def *Drum1* (atom nil))
(def *Drum2* (atom nil))
(def *Drum3* (atom nil))
(def *Drum4* (atom nil))

(defn load-sound [instrument path-to-snd]
    (let [snd-file  (java.io.File. path-to-snd)
          ain        (AudioSystem/getAudioInputStream snd-file)]
    (try
     (let [line-info (DataLine$Info. Clip (.getFormat ain))
           clip (AudioSystem/getLine line-info)]
       (reset! instrument clip)
       (.open @instrument ain))
     (finally
      (.close ain)))))

(defn load-sound-from-url [instrument audio-url]
  (let [ain (AudioSystem/getAudioInputStream audio-url)]
   (try
    (let [line-info (DataLine$Info. Clip (.getFormat ain))
          clip (AudioSystem/getLine line-info)]
      (reset! instrument clip)
      (.open @instrument ain))
    (finally
     (.close ain)))))


(def *default-instruments*
     {*Drum1*  "tonebell01.aif"
      *Drum2*  "clickthump1.wav"
      *Drum3*  "blue.wav"
      *Drum4*  "click2.wav"})

(defn load-default-sounds []
  (doseq [instr (keys *default-instruments*)]
    (let [audio-url (wol-utils/obtain-resource-url
                     *ns*
                     (get *default-instruments* instr))]
      (load-sound-from-url instr audio-url))))


(comment

  (AudioSystem/getAudioInputStream
       (-> (.getClass *ns*)
      (.getClassLoader)
      (.getResourceAsStream "blue.wav")))

  )

(defn play-sound [instr-num]
  (let [var-sym (symbol (format "org.wol.minotaur.audio/*Drum%d*" instr-num))
        instr-var (find-var var-sym)
        instr-atom (deref instr-var)]
    (.start @instr-atom)))

(defn play-sound-from-atom [snd-atom]
  (.stop @snd-atom)
  (.setMicrosecondPosition @snd-atom 0)
  (.start @snd-atom))



(comment
  (play-sound-from-atom *Drum1*)
  (play-sound 1)

  (def *snare* (atom nil))

  (let [snd-file  (java.io.File. "/Users/psantaclara/Desktop/sickofnoisesnaresyet.aif")
        ain        (AudioSystem/getAudioInputStream snd-file)]
    (try
     (let [line-info (DataLine$Info. Clip (.getFormat ain))
           clip (AudioSystem/getLine line-info)]
       (reset! *snare* clip)
       (.open @*snare* ain))
     (finally
      (.close ain))))

  (/  (.getMicrosecondLength @*Drum1*) 1000.0)

  137.142

  (.start @*Drum1*)
  (.stop @*Drum1*)
  (.isActive @*Drum1*)
  (.isRunning @*Drum1*)
  (.setMicrosecondPosition @*Drum1* 0)
  (.getMicrosecondPosition  @*Drum1*)
  (.getMicrosecondLength @*Drum1*)
  (.getBufferSize @*Drum1*)
  (.getLineInfo @*Drum1*)
  (.getControls @*Drum1*)
  (.getBufferSize @*Drum1*)

  (.getLevel @*Drum1*)
  (.getLongFramePosition @*Drum1*)






  )
