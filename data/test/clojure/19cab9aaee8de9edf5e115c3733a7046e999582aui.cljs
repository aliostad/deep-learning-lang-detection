(ns app.ui
  (:require [om.dom :as dom]
            [om.next :as om :refer-macros [defui]]
            [untangled.i18n :refer-macros [tr trf]]
            [untangled.client.core :refer [InitialAppState initial-state]]
            yahoo.intl-messageformat-with-locales))

(defn event->dom-coords
  "Translate a javascript evt to a clj [x y] within the given dom element."
  [evt dom-ele]
  (let [cx (.-clientX evt)
        cy (.-clientY evt)
        BB (.getBoundingClientRect dom-ele)
        x (- cx (.-left BB))
        y (- cy (.-top BB))]
    [x y]))

(defn event->normalized-coords
  "Translate a javascript evt to a clj [x y] within the given dom element as normalized (0 to 1) coordinates."
  [evt dom-ele]
  (let [cx (.-clientX evt)
        cy (.-clientY evt)
        BB (.getBoundingClientRect dom-ele)
        w (- (.-right BB) (.-left BB))
        h (- (.-bottom BB) (.-top BB))
        x (/ (- cx (.-left BB))
             w)
        y (/ (- cy (.-top BB))
             h)]
    [x y]))

(defn render-hover-and-marker
  "Render the graphics in the canvas. Pass the component props and state. "
  [props state]
  (let [canvas (:canvas state)
        hover (:coords state)
        marker (:marker props)
        size (:size props)
        real-marker-coords (mapv (partial * size) marker)
        ; See HTML5 canvas docs
        ctx (.getContext canvas "2d")
        clear (fn []
                (set! (.-fillStyle ctx) "white")
                (.fillRect ctx 0 0 size size))
        drawHover (fn []
                    (set! (.-strokeStyle ctx) "gray")
                    (.strokeRect ctx (- (first hover) 5) (- (second hover) 5) 10 10))
        drawMarker (fn []
                     (set! (.-strokeStyle ctx) "red")
                     (.strokeRect ctx (- (first real-marker-coords) 5) (- (second real-marker-coords) 5) 10 10))]
    (.save ctx)
    (clear)
    (drawHover)
    (drawMarker)
    (.restore ctx)))

(defn place-marker
  "Update the marker in app state. Derives normalized coordinates, and updates the marker in application state."
  [child evt]
  (om/transact! child `[(canvas/place-marker {:coords ~(event->normalized-coords evt (om/get-state child :canvas))})]))

(defn hover-marker
  "Updates the hover location of a proposed marker using canvas coordinates. Hover location is stored in component
  local state (meaning that a low-level app database query will not run to do the render that responds to this change)"
  [child evt]
  (om/update-state! child assoc :coords (event->dom-coords evt (om/get-state child :canvas)))
  (render-hover-and-marker (om/props child) (om/get-state child)))

(defui ^:once Child
  static InitialAppState
  (initial-state [cls _] {:id 0 :size 50 :marker [0.5 0.5]})
  static om/IQuery
  (query [this] [:id :size :marker])
  static om/Ident
  (ident [this props] [:child/by-id (:id props)])
  Object
  (initLocalState [this] {:coords [-50 -50]})
  ; Remember that this "render" just renders the DOM (e.g. the canvas DOM element). The graphical rendering within the canvas is done during event handling.
  (render [this]
    (let [{:keys [size]} (om/props this)]
      ; size comes from props. Transactions on size will cause the canvas to resize in the DOM
      (dom/canvas #js {:width       (str size "px")
                       :height      (str size "px")
                       :onMouseDown (fn [evt] (place-marker this evt))
                       :onMouseMove (fn [evt] (hover-marker this evt))
                       ; This is a pure React mechanism for getting the underlying DOM element.
                       ; Note: when the DOM element changes this fn gets called with nil (to help you manage memory leaks), then the new element
                       :ref         (fn [r]
                                      (when r
                                        (om/update-state! this assoc :canvas r)
                                        (render-hover-and-marker (om/props this) (om/get-state this))))
                       :style       #js {:border "1px solid black"}}))))

(def ui-child (om/factory Child))

(defui ^:once Root
  static InitialAppState
  (initial-state [cls params]
    {:ui/react-key "K" :child (initial-state Child nil)})
  static om/IQuery
  (query [this] [:ui/react-key {:child (om/get-query Child)}])
  Object
  (render [this]
    (let [{:keys [ui/react-key child]} (om/props this)]
      (dom/div #js {:key react-key}
        (dom/button #js {:onClick #(om/transact! this '[(canvas/make-bigger)])} "Bigger!")
        (dom/button #js {:onClick #(om/transact! this '[(canvas/make-smaller)])} "Smaller!")
        (dom/br nil)
        (dom/br nil)
        (ui-child child)))))

