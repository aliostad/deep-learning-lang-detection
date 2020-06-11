(do (use 'overtone.core)
    (use 'late-night.core))


                                        ;(note :e4)

(def lullaby (ref [:e4 :e4 :g4 :e4 :e4 :g5
                   :e4 :g4 :c4 :b4 :a4 :a4 :g4
                   :d4 :e4 :f4 :d4 :d4 :e4 :f4
                   :d4 :f4 :b4 :a4 :g4 :b4 :c4
                   :c4 :c4 :c4 :a4 :f4 :g4
                   :e4 :c4 :f4 :g4 :a4 :e4 :g4
                   :c4 :c4 :c4 :a4 :f4 :g4
                   :e4 :c4 :f4 :g4 :f4 :e4 :d4 :c4]))
(dosync (ref-set lullaby (choose [[:c4 :d#4 :a4 :g#4]
                                  [:c4 :g4 :g#4 :a#4]
                                  [:c3 :c4 :c#5 :g3 :g3 :g#4 :a#5]])))
(note :c#4)
(stop)
(definst ton
  [n 64
   t 1]
  (let [t (impulse 700)
;        arp1 (demand t 0 (dser [0 7 -12 9 12 2] INF))
        s1 (sin-osc (midicps n))
        s2 (sin-osc (+ (lin-lin (lf-noise2 170)
                                -1 1 -15.3 15.3)
                            (midicps (+ 24 n))))
        s3 (sin-osc-fb (+ (lin-lin (lf-noise0 2)
                                   -1 1 -12.3 13.3)
                          (midicps (+ 0 n)))
                       0.4)
        s4 (white-noise)
        e4 (env-gen (perc 0 t 1 -2)
                    1 -300 800 1)
        s4 (bpf s4 e4 0.91)
        a1 (env-gen (perc 0.1 t 1 0)
                    1 1 0 1)
        a2 (env-gen (perc 0.05 (* 0.5 t) 1 -5)
                    1 1 0 1)
        a3 (env-gen (perc 0.005 (* 0.5 t) 1 5)
                    1 1 0 1)
        a4 (env-gen (perc 0.005 (* 0.5 t) 1 -5)
                    1 1 0 1)
        o (mix [(* s1 a1)
                (* s2 a2)
                (* s3 a3)
                (* s4 a4)])
;        o (g-verb o 120 3 :earlyreflevel 0.03 :taillevel 0.4)
        sil (detect-silence o 0.001 0.2 FREE)]
    (out 0 (pan2 o 0 1))))
(ton :n 60)

(def metro-1 (metronome 240))
(metro-bpm metro-1 360)
(def lullaby-index (ref 0))

(defn lullaby-player [l instrument li]
  (let [ll @l
        llii @li]
    (dosync (ref-set li
                     (mod (inc llii)
                          (count ll))))
    (instrument :n (+ (choose [0 -12 12])
                      (note (nth ll llii)))
                :t (choose [0.3 0.4 0.7 0.6]))))

(defn lp []
  (lullaby-player lullaby ton lullaby-index))

(def g (ref [1 1 1 1]))

(dosync (ref-set g [1 1 1]))
(at-zero-beat metro-1 1 g lp)
(stop)
