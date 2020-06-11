
(ns app.comp.task
  (:require-macros [respo.macros :refer [defcomp div span input]])
  (:require [hsl.core :refer [hsl]]
            [respo-ui.style :as ui]
            [respo.core :refer [create-comp]]
            [respo.comp.space :refer [=<]]
            [clojure.string :as string]))

(defn on-input [idx] (fn [e dispatch!] (dispatch! :task/edit [idx (:value e)])))

(def style-task
  {:position :absolute,
   :padding "0 8px",
   :transition-duration "300ms",
   :align-items :center,
   :transform-origin "8% 50%"})

(defn on-touch [idx] (fn [e dispatch!] (dispatch! :pointer/touch idx)))

(def style-done
  {:width 16,
   :height 16,
   :background-color (hsl 200 90 80 0.8),
   :cursor :pointer,
   :transition-duration "300ms",
   :border-radius "50%",
   :box-shadow (str "0 0 4px " (hsl 0 0 0 0.3))})

(defn on-toggle [idx] (fn [e dispatch!] (dispatch! :task/toggle idx)))

(def style-text
  {:width 480,
   :background-color :transparent,
   :color (hsl 0 0 20),
   :font-size 16,
   :font-family "Hind",
   :font-weight 300,
   :padding "0 4px",
   :line-height "16px"})

(defn on-keydown [text idx]
  (fn [e dispatch!]
    (let [event (:event e), shift? (.-shiftKey event)]
      (cond
        (and shift? (= 13 (:keycode e)))
          (if (not (string/blank? text)) (dispatch! :task/add-before idx))
        (and (string/blank? text) (= 8 (:keycode e))) (dispatch! :task/delete idx)
        (and (not shift?) (= 13 (:keycode e)))
          (if (not (string/blank? text)) (dispatch! :task/add-after idx))
        (and shift? (= 9 (:keycode e)))
          (do (.preventDefault event) (dispatch! :pointer/before nil))
        (and (not shift?) (= 9 (:keycode e)))
          (do (.preventDefault event) (dispatch! :pointer/after nil))))))

(defcomp
 comp-task
 (task idx focused? shift)
 (div
  {:style (merge
           ui/row
           style-task
           {:top (str (- (* idx 44) shift) "px")}
           (if (:done? task) {:opacity 0.3})
           (if (and focused? (not (zero? shift))) {:transition-duration "0ms"}))}
  (div
   {:style (merge style-done (if (:done? task) {:transform "scale(0.6)"})),
    :on {:click (on-toggle idx)}})
  (=< 8 nil)
  (input
   {:value (:text task),
    :placeholder "Task content",
    :id (str "input-" idx),
    :style (merge ui/input style-text),
    :on {:input (on-input idx),
         :keydown (on-keydown (:text task) idx),
         :click (on-touch idx)}})))
