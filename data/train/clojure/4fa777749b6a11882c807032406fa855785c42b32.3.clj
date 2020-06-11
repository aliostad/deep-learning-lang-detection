(defn make-rectangle 
  [top-left bottom-right] 
  (defn dispatch 
    [m]
    (cond (= m 0) top-left
          (= m 1) bottom-right
          :else (throw "BOOM")))
  dispatch)

(defn top-left
  [rectangle]
  (rectangle 0))

(defn bottom-right
  [rectangle]
  (rectangle 1))

(defn make-point
  [x y]
  (defn dispatch 
    [m]
    (cond (= m 0) x
          (= m 1) y
          :else (throw "BOOM")))
  dispatch)

(defn x-point
  [point]
  (point 0))

(defn y-point
  [point]
  (point 1))

(defn get-perimeter
  [rectangle]
  (+ (* 2 (- (x-point (bottom-right rectangle))
             (x-point (top-left rectangle))))
     (* 2 (- (y-point (bottom-right rectangle))
                (y-point (top-left rectangle))))))

(defn get-area
  [rectangle]
  (* (- (x-point (bottom-right rectangle))
        (x-point (top-left rectangle)))
     (- (y-point (bottom-right rectangle))
                (y-point (top-left rectangle)))))
