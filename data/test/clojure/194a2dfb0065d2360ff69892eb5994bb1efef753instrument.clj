(ns ssounds.instrument
  (:use
   [overtone.core]))

(boot-external-server)

(definst bell [frequency 440 duration 1000 volume 1 h0 1 h1 0.6 h2 0.4 h3 0.25]
  (let [harmonics [1 2  3 4.2 ]
        proportions [h0 h1 h2 h3]
        proportional-partial
        (fn [harmonic proportion]
          (let [envelope
                (* volume 1/5 (env-gen (perc 0.01 (* proportion (/ duration 1000)))))
                overtone
                (* harmonic frequency)]
            (* 1/2 proportion envelope (sin-osc overtone))))
        partials
        (map proportional-partial harmonics proportions)
        whole (mix partials)]
    (detect-silence whole :action FREE)
    whole))

(bell 200)

(definst bass [freq 110 fuzz 1]
  "bass from Ctford's leipzig_from_scratch"
  (-> freq
      saw
      (rlpf (line:kr (* freq fuzz) (* freq fuzz 2) 1))
      (* (env-gen (perc 0.1 0.4) :action FREE))))

(bass  89 90)

(definst kick [freq 110]
  "kick"
  (-> (line:ar freq (* freq 1/8) 0.5)
      sin-osc
      (+ (sin-osc freq))
      (* (env-gen (perc) :action FREE))
      (* 2/3)))


(defn babs [] (doseq [bb (range 100 200 20) ff (range 4)] (bass bb ff)))

(babs)

(kick 90)
