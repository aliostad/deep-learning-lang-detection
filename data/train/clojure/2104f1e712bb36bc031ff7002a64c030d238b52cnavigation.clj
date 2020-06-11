(ns circle.navigation
  (:require [circle.dispatch :as dispatch]))

(defn forward [buffer line x]
  (cond
   (and (= (inc line) (count buffer))
        (= x (count (buffer line))))
   [line x]

   (< x (count (buffer line)))
   [line (inc x)]

   :otherwise
   [(inc line) 0]))

(defn backward [buffer line x]
  (cond
   (and (= 0 x line))
   [0 0]

   (> x 0)
   [line (dec x)]

   :otherwise
   (let [l (dec line)]
     [l (count (buffer l))])))

(defn vertical-movement [buffer line x p f]
  (if (p line buffer)
    (let [new-line (f line)
          length (count (buffer new-line))]
     (if (> x length)
       [new-line length]
       [new-line x]))
    [line x]))

(defn up-ok-to-move? [line _]
  (> line 0))

(defn up [buffer line x]
  (vertical-movement buffer line x up-ok-to-move? #(dec %)))

(defn down [buffer line x]
  (vertical-movement buffer line x #(< (inc %1) (count %2)) #(inc %)))

(defn cursor-move [f]
  (let [buffer (dispatch/receive :state-get-buffer)
        line (dispatch/receive :state-get-cursor-line)
        x (dispatch/receive :state-get-cursor-x)
        result (f buffer line x)]
    (dispatch/fire :state-move-cursor result)))
