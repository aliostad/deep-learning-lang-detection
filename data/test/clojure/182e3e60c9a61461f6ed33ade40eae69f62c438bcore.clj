(ns gen-manual-synth.core 
  "Generate synths for manual improvisation in live coding sessions"
  (:require 
    [seesaw.core :as ss]
    [overtone.live :refer :all]))

(definst default-instrument [freq 440] (pulse freq))
;straight scale, 4 octaves
(def default-key-assignments {"z" :C2  
                              "x" :D2   
                              "c" :E2   
                              "v" :F2  
                              "a" :G2
                              "s" :A2  
                              "d" :B2  
                              "f" :C3 
                              "q" :D3
                              "w" :E3
                              "e" :F3
                              "r" :G3
                              "1" :A3
                              "2" :B3
                              "3" :C4
                              "4" :D4
                              "m" :E4
                              "," :F4
                              "." :G4
                              "/" :A4
                              "j" :B4
                              "k" :C5
                              "l" :D5
                              ";" :E5
                              "u" :F5
                              "i" :G5
                              "o" :A5
                              "p" :B5
                              "7" :C6
                              "8" :D6
                              "9" :E6
                              "0" :F6 })


(def jammer-key-assignments {})

(defn note->hz [music-note]
  (midi->hz (note music-note)))

(defn play-note [key-down key->synth key->note instrument]
  (swap! key->synth assoc
         (str (.getKeyChar key-down))
         (:id (instrument (note->hz (get key->note  
                                         (str (.getKeyChar key-down)) 0))))))
(defn stop-note [key-up key->synth]
  (kill (get @key->synth 
             (str (.getKeyChar key-up)))))


(defn gen-manual-synth [& {:keys [freq-key-mapping instrument]
                           :or   {freq-key-mapping default-key-assignments
                                  instrument default-instrument}}]

  (let [synth-key-assignments (atom {})

        play-notes  (fn [x] (play-note x synth-key-assignments freq-key-mapping instrument))
        stop-notes  (fn [x] (stop-note x synth-key-assignments))]

    (ss/native!)
    (-> (ss/frame :title "dcbljack's manual synth"
                  :content "Focus this window to use bindings"
                  :height 300
                  :width 300
                  :listen [:key-pressed  (fn [x] (play-notes x))
                           :key-released (fn [x] (stop-notes x))])
        ss/show!)))


