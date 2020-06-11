(ns tutorial.touch-osc
  (:use [overtone.live])
  (:use [tutorial.simple-instrs]))

(def server (osc-server 44100 "matthew-osc-clj"))
(zero-conf-on)

;; connect from phone, then
(osc-listen server (fn [msg] (println msg)) :debug)
(zero-conf-off)

(comment "could also do:"
	 (osc-listen server println :debug))

;; if you want to, remove that listener
(osc-rm-listener server :debug)

;; all done?
(osc-close server)

;; we've a simple instrument available from another ns
(bing 70)

;; add listeners for the piano screeny thing
(for [x (range 1 13)]

  (osc-handle server (str "/1/push" x)
	      (fn [{[io] :args}]
		(when (< 0 io)
		  (bing (+ x 70))))))


;; just a sinewave
(siney)
(stop)

;; use accelerometer
(osc-handle server "/accxyz"
	    (fn [{[x y z] :args}]
	      (ctl siney :vol (scale-range x -10 10 0 1))
	      (ctl siney :cps (scale-range y -10 10 220 880))))
	      