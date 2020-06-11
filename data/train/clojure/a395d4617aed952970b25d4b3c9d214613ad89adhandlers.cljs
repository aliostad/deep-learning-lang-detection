(ns resonate2015.day2.handlers
  (:require-macros
   [cljs-log.core :refer [info warn]])
  (:require
   [resonate2015.day2.tick :as tick]
   [resonate2015.day2.demo :as demo]
   [resonate2015.day2.components.fps :as fps]
   [thi.ng.geom.core.vector :refer [vec2]]
   [thi.ng.geom.rect :as r]
   [re-frame.core :refer [register-handler dispatch]]))

(defn window-size
  [] [(.-innerWidth js/window) (.-innerHeight js/window)])

(defn dispatch-resize
  [e] (dispatch [:resize-window (window-size)]))

(defn dispatch-keydown
  [e] (dispatch [:keydown (.-keyCode e)]))

(defn dispatch-mousemove
  [e] (dispatch [:set-mouse-pos (vec2 (.-clientX e) (.-clientY e))]))

(defn add-dom-listener-if-missing
  [db id fn]
  (if-not (db id)
    (do (.addEventListener js/window (name id) fn)
        (assoc db id fn))
    db))

(defn init-dom-events
  [db]
  (-> db
      (add-dom-listener-if-missing :resize dispatch-resize)
      (add-dom-listener-if-missing :keydown dispatch-keydown)
      (add-dom-listener-if-missing :mousemove dispatch-mousemove)))

(register-handler
 :init-app
 (fn [db _]
   (let [db (-> db
                (init-dom-events)
                (assoc :window-size  (window-size)
                       :mouse-pos    (vec2)
                       :initialized? true))
         db (if-not (:tick/tick db) (tick/init-ticker db) db)]
     (fps/register-fps-counter :fps-counter)
     db)))

(register-handler
 :resize-window
 (fn [db [_ size]]
   (let [size (or size (window-size))]
     (assoc db
            :window-size size
            :view-rect   (apply r/rect size)))))

(register-handler
 :canvas-mounted (fn [db [_ ctx]] (demo/start db ctx)))

(register-handler
 :set-shader (fn [db [_ id]] (assoc db :curr-shader (keyword id))))

(register-handler
 :set-mouse-pos (fn [db [_ mpos]] (assoc db :mouse-pos mpos)))

(register-handler
 :add-shape (fn [db [_ type]] (demo/make-shape db type)))

(register-handler
 :keydown
 (fn [db [_ id]]
   (case id
     0x20 (dispatch [:add-shape :particles]) ;; space
     0x4c (dispatch [:set-shader :lambert])  ;; L
     0x50 (dispatch [:set-shader :phong])    ;; P
     nil)
   db))
