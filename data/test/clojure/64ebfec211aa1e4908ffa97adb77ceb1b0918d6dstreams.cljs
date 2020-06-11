(ns uxbox.ui.canvas.streams
  (:require
   [uxbox.streams :as s]
   [uxbox.ui.streams.mouse :as mouse]
   [uxbox.ui.workspace.streams :as ws]
   [uxbox.ui.tools :as tools]
   [uxbox.shapes.protocols :as shapes]
   [uxbox.geometry :as geo]))

;; Buses

(def mouse-down-stream
  (s/bus))

(def mouse-up-stream
  (s/bus))

(def shapes-bus
  (s/bus))


;; Transformers

(defn- client-coords->canvas-coords
  [[client-x client-y]]
  (if-let [canvas-element (.getElementById js/document "page-canvas")]
    (let [bounding-rect (.getBoundingClientRect canvas-element)
          offset-x (.-left bounding-rect)
          offset-y (.-top bounding-rect)
          new-x (- client-x offset-x)
          new-y (- client-y offset-y)]
      [new-x new-y])
    [client-x client-y]))

;; Handlers

(defn on-mouse-down
  [e]
  (let [coords (client-coords->canvas-coords [(.-clientX e) (.-clientY e)])]
    (s/push! mouse-down-stream coords)))

(defn on-mouse-up
  [e]
  (s/push! mouse-up-stream
           (client-coords->canvas-coords [(.-clientX e) (.-clientY e)])))

(defn set-current-shapes!
  [shapes]
  (s/push! shapes-bus shapes))

(defn move-selections
  [sels [dx dy]]
  (into {} (map (fn [[k s]]
                  [k (shapes/move-delta s dx dy)])
                sels)))


;; Streams

(def mouse-down?
  (s/to-property (s/merge (s/map (constantly true) mouse-down-stream)
                          (s/map (constantly false) mouse-up-stream))))

(defn clamp-coords
  [obs]
  (s/dedupe (s/map geo/clamp obs)))

(def canvas-coordinates-stream
  (s/map client-coords->canvas-coords mouse/client-position))

(defonce canvas-coordinates
  (s/to-property canvas-coordinates-stream))

(def mouse-up? (s/not mouse-down?))

(def mouse-drag-stream
  (s/flat-map-latest (s/true? mouse-down?)
                     (fn [_]
                       (s/take-until
                        (clamp-coords canvas-coordinates-stream)
                        mouse-up-stream))))

(def stroke-stream (s/flat-map-latest
                    (s/true? mouse-down?)
                    (clamp-coords canvas-coordinates)))

(def start-drawing? (s/and ws/tool-selected?
                           mouse-down?))

(def start-drawing-stream
  (s/sampled-by
   (s/combine
    (fn [tool coords]
      (tools/start-drawing tool coords))
    ws/selected-tool-stream
    canvas-coordinates-stream)
   (s/true? start-drawing?)))

(def drawing-stream (s/flat-map start-drawing-stream
                                (fn [shape]
                                  (let [stroke (s/take-while (clamp-coords canvas-coordinates)
                                                             mouse-down?)]
                                    (s/scan (fn [s [x y]]
                                              (shapes/draw s x y))
                                            shape
                                            stroke)))))

(def draw-stream (s/sampled-by drawing-stream
                               (s/true? mouse-up?)))

(def draw-in-progress (s/merge drawing-stream
                               (s/map (constantly nil)
                                      mouse-up-stream)))

(def shapes-stream
  (s/dedupe shapes-bus))

(def start-selection
  (s/and mouse-down?
         (s/not ws/tool-selected?)))

(def intersections (s/sampled-by
                    (s/combine
                       (fn [[x y] shapes]
                         (into {}
                               (comp
                                 (map (juxt :shape/uuid :shape/data))
                                 (filter #(shapes/intersect (second %) x y)))
                               shapes))
                       (clamp-coords canvas-coordinates-stream)
                       shapes-stream)
                    (s/true? start-selection)))

(def selections
  (s/scan
   (fn [selected [shapes intersections]]
     (if (empty? intersections)
         {} ;; deselect everything
         (let [selected-ids (set (keys selected))
               selected-shapes (->> shapes
                                    (filter #(contains? selected-ids (:shape/uuid %)))
                                    (map (fn [s]
                                           [(:shape/uuid s) (:shape/data s)])))]
           (merge intersections selected selected-shapes))))
   {}
   (s/combine vector
              shapes-stream
              intersections)))

(def selected (s/flat-map
               selections
               (fn [sels]
                 (let [drag (s/take-while mouse/delta mouse-down?)]
                   (s/scan move-selections sels drag)))))

(def move-stream (s/sampled-by
                  selected
                  (s/true? mouse-up?)))
