(load-file "./algolib.clj")

(def bpm 100)
(def clk (metronome bpm))

(do
  (defsynth alarm []
    (let [output (* 15 (white-noise))
          output (+ (saw (+ 960 output)) (* 0.1 (saw (+ 240 output))))
          output (* output (env-gen (envelope [0 1 1 0] [0 0.4 0])))]
      (out 0 [output output]))))

(comment)
(defn play-beat
  [clock tick]
  (e-set :clock clock)
  (e-set :tick (+ (wrap-at [1 1
                            1 1
                            1 1
                            1 1
                            1 1
                            2 2
                            2 2
                            2 2
                            2 2
                            2 2]
                           (section-index (e-get :tick 0) 32))
                  (e-get :tick 0)))
  (alarm)
  )

(play clk 0 play-beat)
;(stop)

                                        ; * Three different risers
                                        ; * Three different falls
                                        ; * Three variations on each section
                                        ; * Hemiola and potentially complextro bit should have one
                                        ;   more constantly active instrument in higher register
                                        ; * Optional additive elements to complextro and hemiola
                                        ;   parts
                                        ; √ hemiola part should have AAAB/BBBA pattern instead of
                                        ;   AAAA
                                        ; √ Hemiola and complextro parts should trade ascending /
                                        ;   descending progressions
