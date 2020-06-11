(ns audiogen.core
  (:use overtone.live
        audiogen.input
        audiogen.keydispatch
        audiogen.sysexit)
  (:gen-class))

(defn print-usage
  []
  (println 
  "start typing for instrument playback!
  ,. : change octave
  ESC : quit"))

(defn key-pressed [k]
  (key-dispatch k))

(defn key-released [k]
  )

(defn start
  "convert keystrokes into musical instrument playback"
  []
  (print-usage)
  (send system-exit (fn [c n] n) false)
  (start-listening key-pressed key-released)

  (println "thanks for playing!"))

(defn start-default
  "convert keystrokes into musical instrument playback"
  []
  (use-bindings 'audiogen.sysexit)
  (use-bindings 'audiogen.inst.switcher)
  (start))