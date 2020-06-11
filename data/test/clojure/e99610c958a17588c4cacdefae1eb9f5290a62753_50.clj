(ns sicp-ch3.excercises.3-50
  (require [sicp-ch3.paragraphs.3-51 :refer :all]))


;(defn stream-map [proc & argstreams]
;  (lazy-seq
;    (if (empty? (first argstreams)) '()
;                                    (cons
;                                      (apply proc (map first argstreams))
;                                      (apply stream-map (cons proc (map rest argstreams)))))))


(defn stream-map [proc & argstreams]
    (if (empty? (first argstreams)) '()
                                    (cons-stream
                                      (apply proc (map first argstreams))
                                      (apply stream-map (cons proc (map rest argstreams))))))
