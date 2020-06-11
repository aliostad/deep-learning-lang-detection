
 
;; gui 
;; env X guiparams -> generate view of that state 
(ns flock.2dgui
  (:refer-clojure)
  (:refer msl.seq-numerical)
  (:refer flock.env)
  (:use clojure.contrib.def)
  (:import [javax.swing JFrame JTextField JLabel JPanel BoxLayout])
  (:import [java.awt Color Polygon Dimension])
  (:import [java.awt.image BufferedImage]))

;; g - graphics
(defn render-background [g width height] 	
  (. g setColor (. Color BLACK))
  (. g fillRect 0 0 width height))
(defn render-boids [g e]
  (doseq [b (:boids e)] ((:boid-draw b) b g e)))

;; setup the panel
(defn bound-pixel-widths [e]
  (map #(* (:pixel-per-meter e) %) (flock.env/bound-widths e)))
(defn setup-frame [e] 
  (let [[w0 w1] (bound-pixel-widths e)
	#^JPanel panel (new JPanel)
	#^JFrame frame (new JFrame)]

    ;; configuring panel
    (. panel setPreferredSize (new Dimension w0 w1))

    ;; configuring frame
    (. frame add panel)
    (. frame pack)

;;    (. frame setDefaultCloseOperation JFrame/EXIT_ON_CLOSE)  ;; makes slime disconnected
    (. frame setVisible true)

    ;; paint to this panel
    panel))
    
;; using the image as a double-buffer
(defn render [e panel]
  (let [w0 (. panel getWidth)
	w1 (. panel getHeight)
	#^BufferedImage image (. panel createImage w0 w1)
        #^Graphics g (. image createGraphics)]

    ;; rendering the world
    (render-background g w0 w1)
    (render-boids g e)

    ;; drawing the bufferedimage onto the panel
    (. (. panel getGraphics) drawImage image 0 0 panel)))

;; at demonstration could be faster/slower than optimal.
(defn manage-sleep-time-step [t-start e]
  (let [ts (* 1000 (:time-step e))
	t (. System currentTimeMillis)
	dt (- t t-start)]

    (cond (< ts dt) 
	  (assoc e :time-step (* 0.001 dt))
	  
	  (< dt (* 0.8 ts))
	  (do (Thread/sleep (- ts dt))
	      (assoc e :time-step (* 0.85 (:time-step e))))

	  true 
	  (do (Thread/sleep (- ts dt))
	      e)))) 

;; if we don't want to change the timestep..
(defn manage-time-step [t-start e]
  (let [t (- (* 1000 (:time-step e)) (- (. System currentTimeMillis) t-start))]
    (if (< 0 t)
      (Thread/sleep t))
    e))
      
;; 
(defn demo-upd-boids [e]
  (let [panel (setup-frame e)]

    ;; looping
    (loop [e e]      
      (let [t-start (. System currentTimeMillis)
	    _ (render e panel)
	    e (flock.env/e->upd-boids e)
	    e (manage-sleep-time-step t-start e)]
	(recur e)))))


(defn demo-upd-boids-with-time-step [e]
  (let [panel (setup-frame e)]

    ;; looping
    (loop [e e]      
      (let [t-start (. System currentTimeMillis)
	    _ (render e panel)
	    e (flock.env/e->upd-boids e)
	    e (manage-time-step t-start e)]
	(recur e)))))
	
	

;; draw routines for the boids
;; boid X panel -> draw :)
(ns flock.2dgui.boiddraw
  (:refer-clojure)
  (:refer msl.seq-numerical)
  (:import [javax.swing JFrame JTextField JLabel JPanel BoxLayout])
  (:import [java.awt Color Polygon]))

;; converting the metric to pixel
(defn pos-to-pixel [pos ppm]
  (map #(* ppm %) pos))

(defn rect-draw-f []
  (fn [boid g e]
    (let [ppm (:pixel-per-meter e)
	  radius (/ (* ppm (:size boid)) 2.0)] ;should be rounded to an integer
      (let [[x0 x1] (pos-to-pixel (:pos boid) ppm)]
	(. g setColor (:color boid))
	(. g fillRect (- x0 radius) (- x1 radius) (+ 1 (* 2 radius)) (+ 1 (* 2 radius)))))))

(defn dir-line-draw-f []
  (fn [boid g e]
    (let [ppm (:pixel-per-meter e)
	  radius (/ (* ppm (:size boid)) 2.0)] ;should be rounded to an integer
      (let [[x0 y0] (pos-to-pixel (:pos boid) ppm)
	    [x1 y1] (pos-to-pixel (seq-*-n (:dir boid) (* 0.25 (:speed boid))) ppm)]
	(. g setColor (:color boid))
	(. g fillRect (- x0 radius) (- y0 radius) (+ 1 (* 2 radius)) (+ 1 (* 2 radius)))
	(. g drawLine x0 y0 (+ x0 x1) (+ y0 y1))))))
 
;; (defn centroid-of-isoscale [base height]
;;   (let [sidehalf [(/ base 4.0) (/ height 2.0)]
;; 	sidehalf-vector (seq-unitize (seq-sub-seq sidehalf [base height]))]
;;     [(/ base 2) (* (/ (/ base 2) (nth sidehalf-vector 0)) (nth sidehalf-vector 1))]))
;; (defn displacement-vectors-of-centroid-isoscale [base height]
;;   (let [c (centroid-of-isoscale base height)]
;;     [(seq-sub-seq [(/ base 2.0) 0] c)
;;      (seq-sub-seq [0 height] c)
;;      (seq-sub-seq [base height] c)]))
;; (defn z-centered-rotate [[x y] rad]
;;   (let [m (seq-magnitude [x y])]
;;     [(+ (* (Math/sin rad) m) x)
;;      (+ (* (Math/cos rad) m) y)]
;; ))
;; (defn isoscale-draw-f [base height]
;;   (let [dvs (displacement-vectors-of-centroid-isoscale base height)]
;;     (fn [boid panel]
;;       (let [pos (:pos boid)
;; 	    rad (Math/asin (nth (seq-unitize (:dpos boid)) 0))
;; 	    [[x0 y0] [x1 y1] [x2 y2]] (map #(seq-+-seq pos %) 
;; 					   (map #(z-centered-rotate % rad) 
;; 						dvs))
;; 	    g (. panel getGraphics)
;; 	    p (new Polygon)]

;; 	(. p addPoint x0 y0)
;; 	(. p addPoint x1 y1)
;; 	(. p addPoint x2 y2)

;; 	(. g setColor (:color boid))
;; 	(. g fillPolygon p)))))
