(ns myInstrument.core

(:use [overtone.live]
      ))
(def server (osc-server 44100 "osc-clj"))
(zero-conf-on)

(definst mysaw-wave [note 60 vel 0.2] 
    (let [freq (midicps note)] (* (env-gen (lin 0.2 0.8 0.2) 1 1 0 1 FREE)
        (lpf   (saw freq)(mouse-x 40 5000 EXP))
        vel)))
(definst foo [freq 440] (sin-osc freq))
(defn control-foo 
 [val] 
 (let [val (scale-range val 0 1 50 1000)]
      (ctl foo :freq val)))
(osc-handle server "/1/fader1" (fn [msg] (control-foo (first (:args msg)))))
(on-event [:midi :note-on]
                                  (fn [e]
                                    (let [note (:note e)
                                          vel (* 0.05 (:velocity e))]
                                      (mysaw-wave note vel)))
                                  ::keyboard-handler)
(foo)