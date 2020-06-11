(ns canvas-demos.canvas
  (:require [clojure.string :as string]))

(defmacro with-single-stroke [ctx & body]
  `(do
     (.beginPath ~ctx)
     ~@body
     (.closePath ~ctx)
     (.stroke ~ctx)))

(defmacro with-connected-stroke
  "Wraps drawing logic to manage path state for contiguous curves.
  More than a little hacky."
  [ctx from to & body]
  `(do
     ;; REVIEW: Lexical capture. Classic no no.
     (when-not ~'__path-start
       (.beginPath ~ctx)
       (set! ~'__path-start ~from))

     (when-not (= ~'__point ~from)
       (apply (fn [x# y#] (.moveTo ~ctx x# y#)) ~from))

     ~@body

     (set! ~'__point ~to)

     (when (= ~'__point ~'__path-start)
       (.closePath ~ctx)
       (set! ~'__path-start nil))

     (.stroke ~ctx)))


(defmacro with-style
  "Saves current global draw state, sets up global draw state according to
  style, executes body, then restores global draw state as if this never
  happened.
  Very impure function that lets the rest of the program be a big more pure."
  [ctx style & body]
  `(do
     (.save ~ctx)
     (set-style! ~ctx ~style)
     ~@body
     (when (or (:fill ~style) (:fill-style ~style))
       (.fill ~ctx))
     (.restore ~ctx)
     ;; We don't want to arbitrarily return the last property set.
     nil))
