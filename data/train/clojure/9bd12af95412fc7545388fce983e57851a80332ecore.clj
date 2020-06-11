; ns is the primary way to create and manage namespaces within Clojure. 
; this is very similar to the in-ns function we used in Listing 6-1.
; It creates a namespace if it doesn't exist and then switches to it. 
(ns the-divine-cheese-code.core
  (:gen-class))



(ns the-divine-cheese-code.core.visualization.svg)

(defn latlng->point
  "Convert lat/mng map to comma-separated string"
  [latlng]
  (str (:lat latlng) "," (:lng latlng)))

(defn points
  [locations]
  (clojure.string/join " " (map latlng->point locations)))


(ns the-divine-cheese-code.core)
;; Ensure that the SVG code is evaluated
(require 'the-divine-cheese-code.core.visualization.svg)
;; Refer the namespace so that you don't have to use the
;; fully qualified nae to reference svg functions
(refer 'the-divine-cheese-code.core.visualization.svg)

(def heists [{:location "Cologne, Germary"
              :cheese-name "Archbishop Hildebold's Cheese Pretzel"
              :lat 50.95
              :lng 6.97}
             ])



