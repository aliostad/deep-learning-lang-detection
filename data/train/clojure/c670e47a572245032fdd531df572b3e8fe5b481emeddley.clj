(ns composition-kit.compositions.nerdbait.meddley
  (:require [composition-kit.music-lib.midi-util :as midi])
  (:require [composition-kit.music-lib.tempo :as tempo])
  (:require [composition-kit.music-lib.logical-sequence :as ls])
  (:require [composition-kit.music-lib.logical-item :as i])

  (:use composition-kit.core))

;; F D-    F  D-  Bes C F C
;; F Bes C D- Bes C   A D-
;; Bes F Bes F bes C F

;; TODOS
;;   Fade out strings in chorus 2
;;   Articulation V3P1; Harmony more open also.

(def instruments
  (-> (midi/midi-instrument-map)
      (midi/add-midi-instrument :vln-1-db-leg (midi/midi-port 0))
      (midi/add-midi-instrument :vln-1-ub-leg (midi/midi-port 1))
      (midi/add-midi-instrument :vln-1-marc-long (midi/midi-port 2))
      (midi/add-midi-instrument :vln-1-marc-short (midi/midi-port 3))

      (midi/add-midi-instrument :vln-2-db-leg (midi/midi-port 4))
      (midi/add-midi-instrument :vln-2-ub-leg (midi/midi-port 5))
      (midi/add-midi-instrument :vln-2-marc-long (midi/midi-port 6))
      (midi/add-midi-instrument :vln-2-marc-short (midi/midi-port 7))

      (midi/add-midi-instrument :cl-db-leg (midi/midi-port 8))
      (midi/add-midi-instrument :cl-ub-leg (midi/midi-port 9))
      (midi/add-midi-instrument :cl-marc-long (midi/midi-port 10))
      (midi/add-midi-instrument :cl-marc-short (midi/midi-port 11))

      (midi/add-midi-instrument :vla-db-leg (midi/midi-port 12))
      (midi/add-midi-instrument :vla-ub-leg (midi/midi-port 13))
      (midi/add-midi-instrument :vla-marc-long (midi/midi-port 14))
      (midi/add-midi-instrument :vla-marc-short (midi/midi-port 15))

      (midi/add-midi-instrument :bass-marc-long (midi/midi-port "Bus 2" 0))

      (midi/add-midi-instrument :flute-sus-acc (midi/midi-port "Bus 3" 0))
      (midi/add-midi-instrument :flute-short (midi/midi-port "Bus 3" 1))
      (midi/add-midi-instrument :flute-sus-vib (midi/midi-port "Bus 3" 2))

      (midi/add-midi-instrument :oboe-stac (midi/midi-port "Bus 3" 3))
      (midi/add-midi-instrument :oboe-sus-vib (midi/midi-port "Bus 3" 4))

      (midi/add-midi-instrument :ehorn-stac (midi/midi-port "Bus 3" 6))
      (midi/add-midi-instrument :ehorn-sus-vib (midi/midi-port "Bus 3" 5))

      (midi/add-midi-instrument :bsn-stac (midi/midi-port "Bus 3" 8))
      (midi/add-midi-instrument :bsn-sus-vib (midi/midi-port "Bus 3" 7))

      (midi/add-midi-instrument :fh-leg (midi/midi-port "Bus 4" 0))
      
      (midi/add-midi-instrument :tp-leg (midi/midi-port "Bus 4" 1))
      (midi/add-midi-instrument :tp-sta (midi/midi-port "Bus 4" 2))
      (midi/add-midi-instrument :tbn-leg (midi/midi-port "Bus 4" 3))

      (midi/add-midi-instrument :solov-leg-exp (midi/midi-port "Bus 5" 0))
      (midi/add-midi-instrument :solov-leg-lyr (midi/midi-port "Bus 5" 1))
      (midi/add-midi-instrument :solov-marc (midi/midi-port "Bus 5" 2))
      (midi/add-midi-instrument :solov-stac (midi/midi-port "Bus 5" 3))

      (midi/add-midi-instrument :soloc-leg-exp (midi/midi-port "Bus 5" 4))
      (midi/add-midi-instrument :soloc-leg-lyr (midi/midi-port "Bus 5" 5))
      (midi/add-midi-instrument :soloc-marc (midi/midi-port "Bus 5" 6))


      ))

(def tdelay 150) 
(def clock (tempo/constant-tempo 3 8 77))
(defn try-out [s] (midi-play (-> s (ls/with-clock clock)) :beat-clock clock))


(defn make-alias [s k1 k2] (assoc s k1 (k2 s)))


(def accent-pattern-dynamics
  (fn [i]
    (fn [w]
      (let [b (i/item-beat w)
            b3 (mod b 3/2)
            ]
        (cond
          (= b3 0) (+ 80 (/ b 10))
          :else (-  87 (* 3 b3))))
      )))

(defn control-surge [ctrl p1 p2 beat-len]
  (let [diff (- p2 p1)
        ct   (max diff (- diff))
        dt   (/ beat-len (dec  ct))
        ]
    (map (fn [i] (i/control-event ctrl (+ p1 (* diff (/ i ct))) (* dt i))) (range ct))
    )
  )

(defn control-reset [ctrl inst]
  (->  [ (i/control-event ctrl 80 0) ] (ls/on-instrument inst)))


(def verse-2-violin-1
  (let [alias-instr (-> instruments
                        (make-alias :db :vln-1-db-leg)
                        (make-alias :ub :vln-1-ub-leg)
                        (make-alias :ml :vln-1-marc-long)
                        (make-alias :ms :vln-1-marc-short)
                        )
        ]
    (>>>
     (<*> 
      (-> (lily "
^hold=0.97 
^i=db c2. ^u=ub d4. d4. ^i=db c2. ^i=ub d4. d4. ^i=db d2. ^i=ub e2. ^i=db f2.
^i=ms e16 f e8 ^i=ml d8 ^i=ub c4.
" :relative :c5 :instruments alias-instr)
          (ls/line-segment-dynamics 0 15 (* 8 3) 72)
          )
      (->
       (>>>
        (control-surge 11 30 40 3)
        (rest-for 3)
        (control-surge 11 40 80 3)
        (rest-for 3)
        (control-surge 11 80 95 3)
        (rest-for 3)
        )
       (ls/on-instrument (:db alias-instr))
       )
      (->
       (>>>
        (rest-for 3)
        (control-surge 11 30 40 3)
        (rest-for 3)
        (control-surge 11 40 80 3)
        (rest-for 3)
        (control-surge 11 80 95 3)
        )
       (ls/on-instrument (:ub alias-instr))
       )
      )
     (-> (lily "
^i=ms ^hold=0.86
c8 c c 
c c c 
d d d 
e e e 
f f f
f f f
f f f
g g g
g g g
g g g
a a a
a a g
^hold=0.97 ^i=db f2. d2.
" :relative :c5 :instruments alias-instr)
         (ls/transform :dynamics accent-pattern-dynamics)
         (ls/amplify 0.8)
         )
     (<*>
      (lily "^i=ub ^hold=0.97 c4.*50 ^i=db d2."
            :relative :c5 :instruments alias-instr)
      (->  (>>>
            (control-surge 11 90 80 3/2)
            (rest-for 3)
            (control-surge 11 80 0 3/2)
            )
           (ls/on-instrument (:ub alias-instr)))
      (->  (>>>
            (control-surge 11 90 80 3/2)
            (rest-for 3)
            (control-surge 11 80 0 3/2)
            )
           (ls/on-instrument (:db alias-instr)))
      )
     ;;(rest-for (* 2 3/2))
     
     )))



;;(try-out verse-2-violin-1) ;; TODO next make this more expressive by using the mod wheel (cc 1)
;; So the function I need is
;; "Control-Curve c# curve-fn len"
;; then that takes up 0 -> len and you can chain them with >>>
;; then delegate everything to 'curve' library
;; For ths instruments I'm using in legato section
;;     Because these instruments are smaller, CC 1 (the Mod Wheel) controls the cross-fade of both
;;     vibrato and dynamics at the same time. CC 11 (Expression) performs global volume control. What
;;     is different about the “Niente” versions is that CC 1 can bring the volume all the way to zero
;;     in addition to cross-fading dynamics and vibrato.

(def verse-2-violin-2
  (let [alias-instr (-> instruments
                        (make-alias :db :vln-2-db-leg)
                        (make-alias :ub :vln-2-ub-leg)
                        (make-alias :ml :vln-2-marc-long)
                        (make-alias :ms :vln-2-marc-short)
                        )
        ]
    (>>>
     (<*>
      (-> 
       (lily "
^hold=0.97 
^i=db a2. ^u=ub a4. a4. ^i=db a2. ^i=ub a4. a4. ^i=db bes2. ^i=ub c2. ^i=db c2.
^i=ms c16 d ^i=ml c4 ^i=ub g4.
" :relative :c5 :instruments alias-instr)
       (ls/line-segment-dynamics 0 15 (* 8 3) 72))
      (->
       (>>>
        (control-surge 11 30 40 3)
        (rest-for 3)
        (control-surge 11 40 80 3)
        (rest-for 3)
        (control-surge 11 80 95 3)
        (rest-for 3)
        )
       (ls/on-instrument (:db alias-instr))
       )
      (->
       (>>>
        (rest-for 3)
        (control-surge 11 30 40 3)
        (rest-for 3)
        (control-surge 11 40 80 3)
        (rest-for 3)
        (control-surge 11 80 95 3)
        )
       (ls/on-instrument (:ub alias-instr))
       ))
     (->  (lily "
^i=ms ^hold=0.86
f8 f f
f f f 
f f f
g g g
a a a
a a a
bes bes bes
bes bes bes
c c c
c c c
cis cis cis
cis cis cis

^hold=0.97 ^i=db a2. f2.
" :relative :c4 :instruments alias-instr)
          (ls/transform :dynamics accent-pattern-dynamics)
          (ls/amplify 0.8))
     (lily "^i=ub ^hold=0.97 bes1.*50 ^i=db c1."
           :relative :c5 :instruments alias-instr)

     )))

(def verse-2-viola
  (let [alias-instr (-> instruments
                        (make-alias :db :vla-db-leg)
                        (make-alias :ub :vla-ub-leg)
                        (make-alias :ml :vla-marc-long)
                        (make-alias :ms :vla-marc-short)
                        )
        ]
    (>>>
     (<*>
      (->  (lily "
^hold=0.97 
^i=db f2 ^i=ub e4 ^i=db d2 ^i=ub e4 ^i=db f2 ^i=ub e4 ^i=db d4. ^i=ub f4. ^i=db f2. ^i=ub g2. ^i=db a2.
^i=ms g16 a ^i=ml g4 ^i=ub g4.
" :relative :c4 :instruments alias-instr)
           (ls/line-segment-dynamics 0 15 (* 8 3) 72))
      (->
       (>>>
        (control-surge 11 30 40 3)
        (rest-for 3)
        (control-surge 11 40 80 3)
        (rest-for 3)
        (control-surge 11 80 95 3)
        (rest-for 3)
        )
       (ls/on-instrument (:db alias-instr))
       )
      (->
       (>>>
        (rest-for 3)
        (control-surge 11 30 40 3)
        (rest-for 3)
        (control-surge 11 40 80 3)
        (rest-for 3)
        (control-surge 11 80 95 3)
        )
       (ls/on-instrument (:ub alias-instr))
       ))
     (->  (lily "
^i=ms ^hold=0.86
f8 f f
f f f 
bes bes bes
g g g
a g f
f g a 
bes bes bes
bes c d
c c c
c d c
cis cis cis
cis cis a

^hold=0.97 ^i=db a2. d2.
" :relative :c3 :instruments alias-instr)
          (ls/transform :dynamics accent-pattern-dynamics)
          (ls/amplify 0.8)
          )
     
     )))

(def verse-2-cello
  (let [alias-instr (-> instruments
                        (make-alias :db :cl-db-leg)
                        (make-alias :ub :cl-ub-leg)
                        (make-alias :ml :cl-marc-long)
                        (make-alias :ms :cl-marc-short)
                        )]
    (>>>
     (<*>
      (-> 
       (lily "^hold=0.97 ^inst=ml f2 f'8 e d2 d8 e 
f8 c d f, g bes a bes a g f e
bes4. f8 bes4 
c8 d e c' d e
f16 g f8 c 
f,16 g f8 c 
e16 d c4
c16 d e4"
             :relative :c2 :instruments alias-instr))
      (->
       (>>>
        (control-surge 11 30 40 3)
        (rest-for 3)
        (control-surge 11 40 80 3)
        (rest-for 3)
        (control-surge 11 80 95 3)
        (rest-for 3)
        )
       (ls/on-instrument (:db alias-instr))
       )
      (->
       (>>>
        (rest-for 3)
        (control-surge 11 30 40 3)
        (rest-for 3)
        (control-surge 11 40 80 3)
        (rest-for 3)
        (control-surge 11 80 95 3)
        )
       (ls/on-instrument (:ub alias-instr))
       ))
     (->  (lily "^hold=0.4 ^inst=ms
f,8 g a a bes c 
d e f g e c 
d e f f d a
bes c d d e f
c, d e f g b
a cis e cis b a

^hold=0.97 ^inst=ml d2. c2.
 " :relative :c3 :instruments alias-instr)
          (ls/transform :dynamics accent-pattern-dynamics)
          (ls/amplify 1.03)
          )
     (-> (lily "^hold=0.97 ^inst=ub bes1.*97 ^inst=db f1."
               :instruments alias-instr :relative :c4))
     )
    
    )
  )

(def verse-2-bass
  (>>>
   (rest-for (* 16 3/2))
   (->  (lily "^hold=0.97 f4. f4. bes,4. c4. d4. d4 c8 bes4. bes4. c4. c4. cis4 b8 a4. d4. d4." :relative :c2)
        (ls/line-segment-dynamics 0 80 (* 13 3/2) 104 (* 16 3/2) 80)
        (ls/on-instrument (:bass-marc-long instruments))
        )
   ))

;;(try-out verse-2-bass)

;; These all start at the bes->c 4. transition before the f starts again
(def verse-3-violin-1
  (let [alias-instr (-> instruments
                        (make-alias :db :vln-1-db-leg)
                        (make-alias :ub :vln-1-ub-leg)
                        (make-alias :ml :vln-1-marc-long)
                        (make-alias :ms :vln-1-marc-short)
                        )
        ]

    (>>> 
     (-> (lily "^hold=0.8 ^inst=ms d16 e f e f a g a bes c f e
" :relative :c4 :instruments alias-instr)
         (ls/line-segment-dynamics 0 20 3 70))
     (-> (<*>
          (control-reset 11 (:db alias-instr))
          (control-reset 11 (:ub alias-instr))
          (lily "^hold=0.97 ^inst=db f2. ^inst=ub d2. ^inst=db c2. ^inst=ub d2. ^inst=db d2. ^inst=ub e2. ^inst=db f2. 
^inst=ms e16 f e8 d ^inst=ml c4."
                :relative :c5 :instruments alias-instr)))
     
     (-> (lily "
^i=ms ^hold=0.86
c8 c c 
c c c 
d d d 
e e e 
f f f
f f f
f f f
g g g
g g g
g g g
a a a
a a g
^hold=0.97 ^i=db f2. d2.
" :relative :c5 :instruments alias-instr)
         (ls/transform :dynamics accent-pattern-dynamics)
         (ls/amplify 0.8)
         ))
    )
  )

(def verse-3-violin-2
  (let [alias-instr (-> instruments
                        (make-alias :db :vln-2-db-leg)
                        (make-alias :ub :vln-2-ub-leg)
                        (make-alias :ml :vln-2-marc-long)
                        (make-alias :ms :vln-2-marc-short)
                        )
        ]

    (>>> 
     (-> (lily "^hold=0.8 ^inst=ms bes16 c d c d f e f g g c bes
" :relative :c4 :instruments alias-instr)
         (ls/line-segment-dynamics 0 20 3 70))
     (<*>
      (control-reset 11 (:ub alias-instr))
      (control-reset 11 (:db alias-instr))
      (-> (lily "^hold=0.97 ^inst=db a2. ^inst=ub a2. ^inst=db a2. ^inst=ub a2. ^inst=db bes2. ^inst=ub c2. ^inst=db c2. 
^inst=ms c16 d c8 c8 ^inst=ml g4. "
                :relative :c5 :instruments alias-instr)))
     (->  (lily "
^i=ms ^hold=0.86
f8 f f
f f f 
f f f
g g g
a a a
a a a
bes bes bes
bes bes bes
c c c
c c c
cis cis cis
cis cis cis

^hold=0.97 ^i=db a2. f2.
" :relative :c4 :instruments alias-instr)
          (ls/transform :dynamics accent-pattern-dynamics)
          (ls/amplify 0.8))

     )
    )
  )

(def verse-3-viola
  (let [alias-instr (-> instruments
                        (make-alias :db :vla-db-leg)
                        (make-alias :ub :vla-ub-leg)
                        (make-alias :ml :vla-marc-long)
                        (make-alias :ms :vla-marc-short)
                        )
        ]

    (>>>
     (<*>
      (control-reset 11 (:ub alias-instr))
      (control-reset 11 (:db alias-instr))
      (-> (lily "^hold=0.8 ^inst=db d4 ^inst=ub f8 ^inst=db e4 ^inst=ub g8 ^inst=db c2. a2. c2. a2. f2. g2. a2. 
^inst=ms c16 d e8 f ^inst=ml e4.
" :relative :c3 :instruments alias-instr)
          (ls/line-segment-dynamics 0 30 3 70)))
     (->  (lily "
^i=ms ^hold=0.86
f8 f f
f f f 
bes bes bes
g g g
a g f
f g a 
bes bes bes
bes c d
c c c
c d c
cis cis cis
cis cis a

^hold=0.97 ^i=db a2. d2.
" :relative :c3 :instruments alias-instr)
          (ls/transform :dynamics accent-pattern-dynamics)
          (ls/amplify 0.8)
          )

     )
    )
  )

(def verse-3-cello
  (let [alias-instr (-> instruments
                        (make-alias :db :cl-db-leg)
                        (make-alias :ub :cl-ub-leg)
                        (make-alias :ml :cl-marc-long)
                        (make-alias :ms :cl-marc-short)
                        )
        ]

    (>>>
     (<*>
      (control-reset 11 (:ub alias-instr))
      (control-reset 11 (:db alias-instr))
      (-> (lily "^hold=0.8 ^inst=db bes4 ^inst=ub bes8 ^inst=db c4 ^inst=ub e8 ^inst=db f2. d2. f2. d2. d2. e2. f2. 
^inst=ml c8. g16 c'8 c,4.
" :relative :c3 :instruments alias-instr)
          (ls/line-segment-dynamics 0 30 3 70)))
     (->  (lily "^hold=0.4 ^inst=ms
f,8 g a a bes c 
d e f g e c 
d e f f d a
bes c d d e f
c, d e f g b
a cis e cis b a

^hold=0.97 ^inst=ml d2. c2.
 " :relative :c3 :instruments alias-instr)
          (ls/transform :dynamics accent-pattern-dynamics)
          (ls/amplify 1.03)
          )

     )
    )
  )

(def verse-3-bass
  (>>> (rest-for 3)
       (->  (lily "^hold=1.01 f2. d2. f2. d2. bes2. c2. f2. c2.
f,2. bes4. c4. d2. bes2. c2. a2. d2. c2." :relative :c2)
            (ls/on-instrument (:bass-marc-long instruments))
            (ls/line-segment-dynamics 0 65 24 74 45 108 52 70)
            )))


(def verse-3-flute
  (let [ai (-> instruments
               (make-alias :sv :flute-sus-vib)
               (make-alias :sa :flute-sus-acc)
               (make-alias :st :flute-short)
               )]
    (>>>
     (rest-for 3)
     (-> (lily "^hold=0.97 
^inst=sv c4. c8 ^inst=st c16 d f e ^inst=sv f4. d4.
^inst=sv c4. c8 ^inst=st c16 d f e ^inst=sv f4. a4.
^inst=st bes16*120 a g f e d c d e f g c
d c bes a g f e f g a bes g
^inst=sv a2. bes4. c4.


^inst=sa f,2 ^inst=st a8 a
bes16 g f d bes8 ^inst=sv c4.
^inst=st d16 e f g bes g ^inst=sa a4.
bes4. 
^inst=st c16 g f d c bes a32 bes d bes ^inst=sv c4 c'4.
^inst=sa cis2. ^inst=sv d2. c2.

" :relative :c5 :instruments ai))
     )))
#_(try-out verse-3-flute)

(def verse-3-oboe
  (let [ai (-> instruments
               (make-alias :ot :oboe-stac)
               (make-alias :ov :oboe-sus-vib)
               )]
    (>>>
     (rest-for 3)
     (-> (lily "^hold=0.97 
r2. r2.
r2. r2.
^inst=ov f4.*104 ^hold=0.7 ^inst=ot e16 f g a bes e

d c bes a g f e f g a bes g
^hold=0.97 ^inst=ov f2. d4. e4.

^inst=ov a'2 ^inst=ot c8 c
d16 bes a f d8 ^inst=ov e4.
^inst=ot f16 g f e d c ^inst=ov c4.
f4. 
^inst=ot e16 c bes f e d e32 g e f ^inst=ov e4 e'4.
^inst=ov e2. ^inst=ov f2. e2.

" :relative :c4 :instruments ai))
     )))

(def verse-3-ehorn
  (let [ai (-> instruments
               (make-alias :et :ehorn-stac)
               (make-alias :ev :ehorn-sus-vib)
               )]
    (>>>
     (rest-for 3)
     (-> (lily "^hold=0.97 
r2. r2.
r2. r2.
^inst=ev d4.*104 ^hold=0.7 ^inst=et c8 e8 f16 g
bes a f   e d c bes d e f f8
^hold=0.97 ^inst=ev c2. bes4. c4.

^inst=ev f2 ^inst=et f8 e ^inst=ev d4. c4.
^inst=et d8 f a ^inst=ev d4. bes4 f,8 g'4.
c2. e2. d2. c2.

" :relative :c4 :instruments ai))
     )))

(def verse-3-bassoon
  (let [ai (-> instruments
               (make-alias :bt :bsn-stac)
               (make-alias :bv :bsn-sus-vib)
               )]
    (>>>
     (rest-for 3)
     (-> (lily "^hold=0.97 
r2. r2.
r2. r2.
^inst=bv bes4.*104 c4. 
^hold=0.7 ^inst=bt 
bes8 f' bes, c g' c


^hold=0.97 ^inst=bv c2. bes4. g4.

f2 a4 bes8 d bes c4. 
d2 f4 bes,4. c8 c, g'
c2 c,4 a'2 cis4 d2. c2.

" :relative :c3 :instruments ai))
     ))
  )

(def fh-swells
  (<*>
   (-> (lily "^hold=0.96 a2. bes4. c4. d2. bes2. c2. cis2. d2. c2." :relative :c4)
       (ls/on-instrument (:fh-leg instruments))
       )
   (-> (lily "^hold=0.96 f2. d4.   e4. f2. f2.   g2. a2. a2. a2." :relative :c4)
       (ls/on-instrument (:fh-leg instruments))
       )
   (->  (>>>
         (<*>
          (control-surge 1 30 100 3)
          (control-surge 11 70 100 3)
          )
         (control-surge 1 40 97 3/2)
         (control-surge 1 60 104 3/2)
         (control-surge 1 70 104 3)
         (control-surge 1 80 104 3)
         (control-surge 1 80 104 3)

         (control-surge 1 97 110 3);; the CIS
         (control-surge 1 70 84 3)
         (control-surge 1 50 72 3)
         
         
         )
        (ls/on-instrument (:fh-leg instruments))
        )
   ))


(def tp-swells
  (-> 
   (<*>
    (lily "^hold=0.96 c2. f4.   g4. a2. f2.  e2. e2. d2. c2." :relative :c4 )
    (lily "^hold=0.96 f2. bes4. c4. d2. d2.  g2. a2. f2. f2." :relative :c4 )
    (>>>
     (<*>
      (control-surge 1 30 100 3)
      (control-surge 11 70 100 3)
      )
     (control-surge 1 40 97 3/2)
     (control-surge 1 60 104 3/2)
     (control-surge 1 70 104 3)
     (control-surge 1 80 104 3)
     
     (control-surge 1 80 104 3)

     (control-surge 1 97 110 3);; the CIS
     (control-surge 1 70 84 3)
     (control-surge 1 50 72 3)
     
     
     )
    )
   (ls/on-instrument (:tp-leg instruments))
   ))


(def tbn-swells
  (-> 
   (<*>
    (lily "^hold=0.96 f2. bes4. c4. d2. bes2.  c4. e,4. cis'4. a4. d2. c2." :relative :c3 )
    (>>>
     (<*>
      (control-surge 1 30 100 3)
      (control-surge 11 70 100 3)
      )
     (control-surge 1 40 97 3/2)
     (control-surge 1 60 104 3/2)
     (control-surge 1 70 104 3)
     (control-surge 1 80 104 3)
     
     (control-surge 1 80 104 3)

     (control-surge 1 97 110 3);; the CIS
     (control-surge 1 70 84 3)
     (control-surge 1 50 72 3)
     )
    )
   (ls/on-instrument (:tbn-leg instruments))
   ))

(def solo-violin
  (let [ai (-> instruments
               (make-alias :exp :solov-leg-exp )
               (make-alias :lyr :solov-leg-lyr )
               (make-alias :marc :solov-marc )
               (make-alias :stac :solov-stac )
               )
        ]
    (>>>
     (<*>
      (lily "^hold=0.97 ^i=exp f2.*120 bes2.*120 a2. c2." :relative :c5 :instruments ai)
      (->
       (>>>
        (control-surge 11 90 102 3)
        (control-surge 11 94 112 3)
        (control-surge 11 94 112 3)
        (control-surge 11 94 112 3)
        )
       (ls/on-instrument (:solov-leg-exp instruments))
       )
      )

     (<*>
      (lily "^hold=0.97 ^i=lyr d4. ^hold=0.8 ^i=stac d8*60 d e f*84 e d ^hold=0.97 ^i=lyr d4.*97
^i=stac ^hold=0.8 c16 f a8 a g16 a f c f e d c bes a g c bes a g f e f
 " :relative :c5 :instruments ai)
      (->
       (>>>
        (control-surge 11 90 102 3/2)
        (rest-for 3)
        (control-surge 11 88 76 3/2)

        )
       (ls/on-instrument (:solov-leg-lyr instruments))
       )
      (->
       (>>>
        (rest-for 3/2)
        (control-surge 11 60 82 3/2)
        (control-surge 11 82 64 3/2)
        (control-surge 11 72 84 2)
        (control-surge 11 84 17 2)
        (control-surge 11 84 17 2)
        )
       (ls/on-instrument (:solov-stac instruments))
       )
      )
     (<*>
      (lily "^hold=0.97 ^i=exp f2*120 a4 bes2.*120 a2. c2. d2. f1." :relative :c4 :instruments ai)
      (->
       (>>>
        (control-surge 11 90 102 3)
        (control-surge 11 94 112 3)
        (control-surge 11 94 112 3)
        (control-surge 11 94 112 3)
        )
       (ls/on-instrument (:solov-leg-exp instruments))
       )
      )

     )
    
    ))
;;(try-out solo-violin)

(def solo-cello
  (let [ai (-> instruments
               (make-alias :exp :soloc-leg-exp )
               (make-alias :lyr :soloc-leg-lyr )
               (make-alias :marc :soloc-marc )
               )
        ]
    (>>>
     (<*>
      (lily "^hold=0.97 ^inst=marc f16*120 g a bes c8 e ^inst=lyr f4 ^inst=exp d4. bes4. c4. ^inst=marc c16*77 d c*80 bes*84 a d*78 ^inst=lyr c2.
bes4. f4 g8 f2. a4 c8 f4. c2.
^i=exp bes2 c4 d2. c2. f2. f2. f4. a4.
"
            :relative :c3 :instruments ai)
      (->
       (>>>)
       (ls/on-instrument (:marc ai))
       )
      (->
       (>>>
        (rest-for 3/2)
        (control-surge 11 70 80 2)
        (rest-for 6)
        (control-surge 11 72 102 15)
        )
       (ls/on-instrument (:lyr ai))
       )
      (->
       (>>>
        (rest-for 24)
        (control-surge 11 70 90 3)
        (control-surge 11 82 94 3)
        (control-surge 11 90 106 3)
        (control-surge 11 82 97 3)
        (control-surge 11 77 92 3)
        (control-surge 11 70 86 3)
        )
       (ls/on-instrument (:exp ai))
       )

      ))
    )
  )
;;(try-out (<*>  solo-cello solo-violin))

(map ls/beat-length  (list
                      verse-2-violin-1
                      verse-2-violin-2
                      verse-2-viola
                      verse-2-cello
                      verse-2-bass
                      ))

(def final-song
  (->
   (>>>
    (rest-for tdelay)
    (rest-for 6)
    (<*>
     verse-2-violin-1
     verse-2-violin-2
     verse-2-viola
     verse-2-cello
     verse-2-bass
     )
    (rest-for (* 10 3/2))
    (<*>
     (<*>
      verse-3-violin-1
      verse-3-violin-2
      verse-3-viola
      verse-3-cello
      verse-3-bass)

     (<*>
      verse-3-flute
      verse-3-oboe
      verse-3-ehorn
      verse-3-bassoon
      )
     (>>> (rest-for 27) ;; 8 measures plus that extra we get for the intro
          (<*>
           fh-swells
           tp-swells
           tbn-swells))
     )
    (<*>
     solo-violin
     solo-cello
     )
    (rest-for 180)
    )
   (ls/with-clock clock)
   )
  )

(def play-meddley false)
(def ag
  (when play-meddley
    (midi-play
     final-song
     ;;:samples [ {:file "/Users/paul/Desktop/MM/Bouncedown.wav"  :zero-point  (* (tempo/beats-to-time clock -3) 1000000)}]
     :beat-clock clock
     :beat-zero tdelay ;;tdelay ;;(+ 50 tdelay)
     ))

  )

;;(midi/all-notes-off)


