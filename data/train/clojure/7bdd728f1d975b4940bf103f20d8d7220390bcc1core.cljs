(ns reagent-leaflet.core
  (:require [reagent.core :as reagent :refer [atom]]))

;;;;;;;;;
;; Define the React lifecycle callbacks to manage the LeafletJS
;; Javascript objects.

(declare update-leaflet-geometries)

(defn- leaflet-did-mount [this]
  "Initialize LeafletJS map for a newly mounted map component."
  (let [mapspec (:mapspec (reagent/state this))
        leaflet (js/L.map (:id mapspec))
        view (:view mapspec)
        zoom (:zoom mapspec)]
    (.setView leaflet (clj->js @view) @zoom)
    (doseq [{:keys [type url] :as layer-spec} (:layers mapspec)]
      (let [layer (case type
                    :tile (js/L.tileLayer
                           url
                           (clj->js {:attribution (:attribution layer-spec)})
                                    )
                    :wms (js/L.tileLayer.wms
                          url
                          (clj->js {:format "image/png"
                                    :fillOpacity 1.0
                                    })))]
        ;;(.log js/console "L.tileLayer = " layer)
        (.addTo layer leaflet)))
    ;;(.log js/console "L.map = " leaflet)
    (reagent/set-state this {:leaflet leaflet
                             :geometries-map {}})

    ;; If mapspec defines callbacks, bind them to leaflet
    (when-let [on-click (:on-click mapspec)]
      (.on leaflet "click" (fn [e]
                             (on-click [(-> e .-latlng .-lat) (-> e .-latlng .-lng)]))))

    ;; Add callback for leaflet pos/zoom changes
    ;; watcher for pos/zoom atoms
    (.on leaflet "move" (fn [e]
                          (let [c (.getCenter leaflet)]
                            (reset! zoom (.getZoom leaflet))
                            (reset! view [(.-lat c) (.-lng c)]))))
    (add-watch view ::view-update
               (fn [_ _ old-view new-view]
                 ;;(.log js/console "change view: " (clj->js old-view) " => " (clj->js new-view) @zoom)
                 (when (not= old-view new-view)
                   (.setView leaflet (clj->js new-view) @zoom))))
    (add-watch zoom ::zoom-update
               (fn [_ _ old-zoom new-zoom]
                 (when (not= old-zoom new-zoom)
                   (.setZoom leaflet new-zoom))))
    ;; If the mapspec has an atom containing geometries, add watcher
    ;; so that we update all LeafletJS objects
    (when-let [g (:geometries mapspec)]
      (add-watch g ::geometries-update
                 (fn [_ _ _ new-geometries]
                   (update-leaflet-geometries this new-geometries))))))

(defn- leaflet-will-update [this old-state new-state]
  (update-leaflet-geometries this (-> this reagent/state :mapspec :geometries deref)))

(defn- leaflet-render [this]
  (let [mapspec (-> this reagent/state :mapspec)]
  [:div {:id (:id mapspec)
         :style {:width (:width mapspec)
                 :height (:height mapspec)}}]))

;;;;;;;;;;
;; Code to sync ClojureScript geometries vector data to LeafletJS
;; shape objects.

(defmulti create-shape :type)

(defmethod create-shape :polygon [{:keys [coordinates]}]
  (js/L.polygon (clj->js coordinates)
                        #js {:color "red"
                             :fillOpacity 0.5}))

(defmethod create-shape :line [{:keys [coordinates]}]
  (js/L.polyline (clj->js coordinates)
                 #js {:color "blue"}))

(defmethod create-shape :point [{:keys [coordinates]}]
  (js/L.circle (clj->js (first coordinates))
               10
               #js {:color "green"}))

(defn- update-leaflet-geometries [component geometries]
  "Update the LeafletJS layers based on the data, mutates the LeafletJS map object."
  (let [{:keys [leaflet geometries-map]} (reagent/state component)
        geometries-set (into #{} geometries)]
    ;; Remove all LeafletJS shape objects that are no longer in the new geometries
    (doseq [removed (keep (fn [[geom shape]]
                          (when-not (geometries-set geom)
                            shape))
                        geometries-map)]
      ;;(.log js/console "Removed: " removed)
      (.removeLayer leaflet removed))

    ;; Create new shapes for new geometries and update the geometries map
    (loop [new-geometries-map {}
           [geom & geometries] geometries]
      (if-not geom
        ;; Update component state with the new geometries map
        (reagent/set-state component {:geometries-map new-geometries-map})
        (if-let [existing-shape (geometries-map geom)]
          ;; Have existing shape, don't need to do anything
          (recur (assoc new-geometries-map geom existing-shape) geometries)

          ;; No existing shape, create a new shape and add it to the map
          (let [shape (create-shape geom)]
            ;;(.log js/console "Added: " (pr-str geom))
            (.addTo shape leaflet)
            (recur (assoc new-geometries-map geom shape) geometries)))))))



;;;;;;;;;
;; The LeafletJS Reagent component.

(defn leaflet [mapspec]
  "A LeafletJS map component."
  (reagent/create-class
    {:get-initial-state (fn [_] {:mapspec mapspec})
     :component-did-mount leaflet-did-mount
     :component-will-update leaflet-will-update
     :render leaflet-render}))

