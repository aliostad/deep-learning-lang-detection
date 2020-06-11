(ns brea.core)

;;(use 'overtone.live)


;; Loading samples:
;; (def piano (sample "~/Music/Samples/grpiano.wav"))
;; Playing: (piano)

(def sample-session
     '("Sample Session, see also http://blog.josephwilk.net/clojure/creating-instruments-with-overtone.html"

       ;; simple instruments
       (definst i-saw [] (saw 220))
       (kill i-saw) ; to mute

       (definst trem [freq 440 depth 10 rate 6 length 3]
         (* 0.3
            (line:kr 0 1 length FREE)
            (saw (+ freq (* depth (sin-osc:kr rate))))))
       
       ;; piano sample
       (def piano (sample "~/Music/Samples/grpiano.wav"))
       (piano)

       (definst i-piano
                [note 60 level 1 loop? 0]
                (scaled-play-buf 1 piano :level level :loop loop? :action FREE))

       ;; rate changes sound's tone
       (definst i-piano2
                [note 60 level 1 rate 1 loop? 0 attack 0 decay 1 sustain 1 release 0.1 curve -4 gate 1]
                (let [env (env-gen (adsr attack decay sustain release level curve)
                            :gate gate
                            :action FREE)]
                  (scaled-play-buf 1 piano :rate rate :level level :loop loop? :action FREE)))
       ;; different notes - (i-piano2 :rate 1) (i-piano2 :rate 0.7) (i-piano2 :rate 1.2)

       ;; flute sample + instrument
       (def flute (sample "~/Music/Samples/Flute.wav"))
       (definst sampled-flute-vibrato
         [note 60 level 1 rate 1 loop? 0 attack 0 decay 1 sustain 1 release 0.1 curve -4 gate 1]
         (let [buf (index:kr (:id index-buffer) note)
               env (env-gen (adsr attack decay sustain release level curve)
                            :gate gate
                            :action FREE)]
           (* env (scaled-play-buf 2 buf :level level :loop loop? :action FREE))))

       't1))

(def ff-tracks
     '("Tracks"
       ;; Refer to https://github.com/overtone/overtone/wiki/Pitches-and-Chords

       (def t1 [:C2 :E2 :C3 :E3 :C4 :E4 :C5 :E5 :C6 :E5 :C5 :E4 :C4 :E3 :C3 :E2
                :A1 :C2 :A2 :C3 :A3 :C4 :A4 :C5 :A5 :C5 :A4 :C4 :A3 :C3 :A2 :C2])
       (def t2 [:D2 :G2 :D3 :G3 :D4 :G4 :D5 :G5 :G5 :D5 :G4 :D4 :G3 :D3 :G2 :D2
                :B1 :E2 :B2 :E3 :B3 :E4 :B4 :E5 :E5 :B4 :E4 :B3 :E3 :B2 :E2 :B1])

       ;; Plays Final Fantasy prelude with the given instrument
       (defn ff-prelude [instrument delta]
           (let [time (now)]
             (doseq [[idx a] (map-indexed vector t1)] (at (+ time (* idx delta)) (instrument a)))
             (doseq [[idx a] (map-indexed vector t2)] (at (+ time (/ delta 2) (* idx delta)) (instrument a)))))

       ;; Define saw instrument and play FF prelude
       (definst saw-wave [freq 440 attack 0.01 sustain 0.4 release 0.1 vol 0.4] 
         (* (env-gen (env-lin attack sustain release) 1 1 0 1 FREE)
                     (saw freq)
                     vol))

       (definst sin-wave [freq 440 attack 0.01 sustain 0.4 release 0.1 vol 0.4] 
         (* (env-gen (env-lin attack sustain release) 1 1 0 1 FREE)
                     (sin-osc freq)
                     vol))

       ;;(definst sin-wave [freq 440 attack 0.01 sustain 0.4 release 0.1 vol 0.4]  (* (env-gen (env-lin attack sustain release) 1 1 0 1 FREE) (sin-osc freq) vol))

       (defn play-note [instrument music-note] (instrument (midi->hz (note music-note))))

       (ff-prelude (fn [x] (play-note saw-wave x)) 200)
       (ff-prelude (fn [x] (play-note sin-wave x)) 200)

       "End"))

(defn foo
  "I don't do a whole lot."
  [x]
  (println x "Hello, World!"))
