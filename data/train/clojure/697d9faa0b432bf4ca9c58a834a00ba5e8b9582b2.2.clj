(defn make-segment 
  [start finish] 
  (defn dispatch 
    [m]
    (cond (= m 0) start
          (= m 1) finish
          :else (throw "BOOM")))
  dispatch)
  
(defn start-segment
  [segment]
  (segment 0))
    
(defn end-segment
  [segment]
  (segment 1))
  
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

(defn midpoint-segment
  [segment]
  (defn midpoint
    [point]
    (/ (+ (point (start-segment segment))
          (point (end-segment segment)))
       2))
  (print-p (make-point (midpoint x-point) (midpoint y-point))))
  
(defn print-p
  [p]
  (str "("(x-point p)","(y-point p)")"))

  ; (midpoint-segment (make-segment (make-point 0 0) (make-point 4 4)))
  ; "(2,2)"
  ; (midpoint-segment (make-segment (make-point 6 3) (make-point 2 8.0)))
  ;   "(4,5.5)"
  ;   