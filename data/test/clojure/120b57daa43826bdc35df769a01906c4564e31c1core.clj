(ns voxels.core
  (:use [quil.core]
        [toxi.geom.core :only [add vec3d normalize scale] :rename {scale scalevec}]
        )
  (:require [overtone.live :as ol]
            [overtone.inst.synth :as synth]
            [overtone.music.pitch :as pitch])
)

(def notes [])
(def rows 8)
(def cols 8)
(def x-degrees (take cols (cycle [:i :ii :iii :iv :v :vi :vii])))
(def y-tones (take rows (cycle [:C2 :G2 :D3 :A4 :E4 :B5 :F#5 :C#6])))
(def play-scale :lydian)
(defn some-cells 
  []
  (take (* rows cols) (repeatedly #(rand-int 2))))

(def cells [])

(defn draw-row
  [y]
  (line 0 y (width) y)
  )

(defn draw-column
  [x]
  (line x 0 x (height))
  )

(defn draw-rows
  [rows]
  (doall 
   (map draw-row (take-while (fn [y] (<= y (height))) (iterate (fn [y] (+ (/ (height) rows) y)) (/ (height) rows)))))
)

(defn draw-columns
  [columns]
  (doall 
   (map draw-column (take-while (fn [x] (<= x (width))) (iterate (fn [x] (+ (/ (width) columns) x)) (/ (width) columns)))))
)

(defn draw-grid
  [columns rows]
  (draw-rows rows)
  (draw-columns columns)
)

(defn index->xy
  [idx]
  (let [x (rem idx cols) y (/ (- idx x) rows)]
    [x y]
    )
)

(defn xy-cell 
  [idx cell]
  (if (> cell 0) (index->xy idx) nil)
)


(defn live-cells
  []
  (keep #(if-not (nil? %) %) (map-indexed xy-cell cells))
)

(defn neighbor-indeces
  [idx]
  [ (- idx (+ rows 1)) (- idx rows) (- idx (- rows 1))  (- idx 1)  (+ idx 1)  (+ idx (- rows 1)) (+ idx rows) (+ idx (+ rows 1)) ]
)

(defn index-living-neighbors
  ; 
  [idx]
  (count (filter #(> % 0) (remove nil? (map #(nth cells % nil) (neighbor-indeces idx)))))
)

(defn play-one
  [metronome beat instrument note dur]
  (let [end (+ beat dur)]
    (if note
      (let [id (ol/at (metronome beat) (instrument note))]
        (ol/at (metronome end) (ol/ctl id :gate 0))))
    end))

(defn play
  ([metronome inst score]
     (play metronome (metronome) inst score))
  ([metronome beat instrument score]     
     (let [cur-note (first score)]
       (when cur-note
         (let [next-beat (play-one metronome beat instrument cur-note 1)]
           (ol/apply-at (metronome next-beat) play metronome next-beat instrument
             (next score) []))
         )      
)))

(defn xy-note
  [x y]
  (if (== x 0) 
    (pitch/note (nth y-tones y)) 
    (if (== x 7) 
      (pitch/note (nth y-tones y)) 
      (nth (pitch/degrees->pitches [(nth x-degrees x)] play-scale (nth y-tones y)) 0)
      )
    )
)


(defn index-note
  [idx]
  (let [xy (index->xy idx)]
    (xy-note (nth xy 0) (nth xy 1))
  )
)


(defn fill-cell
  [cell]
  (no-stroke)
  (fill 226 205 50)
  (let 
      [x (nth cell 0) y (nth cell 1)]   
      (rect (* x (/ (width) cols)) (* y (/ (height) rows)) (/ (width) cols) (/ (height) rows))
    )
)

(defn fill-cells
  [cells]
  (dorun (map fill-cell cells))
)

(defn live-or-die
  [idx cell]
  (let [neighbors (index-living-neighbors idx) 
        living (if (< neighbors 2) 0 (if (> neighbors 3) 0 (if (== neighbors 3) 1 cell)))]    
    [ living (if (not= living cell) (index-note idx) nil) ]
    )
)

(defn do-life
  []
  (let [year (doall (map-indexed live-or-die cells))]
    (def cells (doall (map first year)))
    (def notes (keep #(if-not (nil? %) %) (doall (map #(nth % 1) year))))
    )
)

(defn setup
  []  
  (smooth)
  (no-stroke)
  (fill 226)
  (background 0)
  (def cells (some-cells))  
)

(defn draw
  []
  ; foo
  ;(if (> (frame-count) 0) (do-life))

  (background 0)
  (stroke 255)
  (do-life) 
  (play (ol/metronome 255) synth/ping notes)
  (draw-grid rows cols)
  (fill-cells (live-cells))
)

(defn run
  []
  (sketch 
   :setup setup
   :draw draw
   :size [750 750]
   :renderer :p2d)
)
