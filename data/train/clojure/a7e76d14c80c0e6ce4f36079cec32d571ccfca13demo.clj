(ns demo
  (:use [overtone.device.audiocubes] 
        [overtone.live]))

;; Example from the SC book (actually taken from one of Sam Aaron's videos)
(definst wobble [noise-rate 3 freq-mul 15 variance 3 base-note 80 wobble-mul 1 echo 2]
  (let [noise (lf-noise1 noise-rate)
        saws (mul-add (lf-saw (* wobble-mul 5)) variance 2)
        freq (midicps (mul-add noise freq-mul (+ saws base-note)))
        src (* 1.0 (sin-osc freq))]
       (comb-n src 1 0.3 echo)))

;; Start the noise!
(wobble)

;; Cube handler - assumes a single connected cube (ignores the 'cube' value on messages)
;; and maps proximity sensors to base-note, echo and noise-rate properties of the wobble
;; instrument. The same sensors (the ones on faces 0,1 and 2) are mapped to RGB values so
;; you get a glowing cube controlling the instrument parameters when manipulated.
;; This assumes an audiocube OSC bridge running on localhost sending messages on port 7000
;; and receiving them on port 8000, i.e. 'acosc.exe 127.0.0.1 7000 8000' from the shell.
(let [client (osc-client "localhost" 8000)
      colour {:red (atom 0.0) :green (atom 0.0) :blue (atom 0.0)}] 
  (osc-handle 
    (osc-server 7000) "/audiocubes"
    (mk-cube-handler :sensor-updated ; Sensor value updated
                     (fn [cube face sensor-value] 
                       (do
                         (case face
                           0
                           (do
                             (reset! (colour :red) (* sensor-value 255))
                             (ctl wobble :base-note (+ 50 (* sensor-value 60))))
                           1
                           (do
                             (reset! (colour :green) (* sensor-value 255))
                             (ctl wobble :echo (* sensor-value 40)))                           
                           2
                           (do
                             (reset! (colour :blue) (* sensor-value 255))
                             (ctl wobble :noise-rate (+ 1 (* sensor-value 40))))
                           nil))
                       (set-colour client cube @(colour :red) @(colour :green) @(colour :blue))
                       )
                     )))