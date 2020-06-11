(ns mq.utils
  (:require [re-frame.core :as rf]
            [reagent.core :as reagent]
            [clojure.string :as string]
            [cljs.core.match :refer-macros [match]]
            [CodeMirror]
            [Octave]
            [FileSaver]
            [JSZip]
            [Bootstrap]
            [Tether]))




(defn not-every-nil? [map]
  (not-every? (comp nil? second) map))

(defn dispatch [event]
  (fn [e]
    (do
      (.preventDefault e)
      (rf/dispatch event)
      false)))

(defn code-mirror [{:keys [line-numbers read-only on-save]}]
  (let [cm-atom (atom nil)]
    (reagent/create-class
      {:reagent-render
       (fn [_]
         [:textarea {:auto-complete "off"}])
       :component-did-mount
       (fn [this]
         (let [cm (.fromTextArea js/CodeMirror
                                 (reagent/dom-node this)
                                 #js {:mode           "octave"
                                      :lineNumbers    line-numbers
                                      :readOnly       read-only
                                      :viewportMargin js/Infinity})]
           (set! (.-save (.-commands js/CodeMirror)) on-save)
           (.setValue cm (or (:default-value (reagent/props this)) ""))
           (reset! cm-atom cm)))
       :component-did-update
       (fn [this]
         (when (string/blank? (.getValue @cm-atom))
           (.setValue @cm-atom (:default-value (reagent/props this)))
           (set! (.-save (.-commands js/CodeMirror)) (:on-save (reagent/props this)))))})))



(defn format-date [date-string]
  (let [date (js/Date. date-string)]
    (str (.getDate date) "." (.getMonth date) "." (.getFullYear date) " " (.getHours date) ":" (.getMinutes date))))


(defn hex->zip [hex-string on-load on-failure]
  (let [byte-array
        (js/Uint8Array.
          (->>
            (subs hex-string 2)
            (partition 2)
            (map (fn [[x y]] (js/parseInt (str x y) 16)))
            clj->js))]
    (->
      (.loadAsync js/JSZip byte-array)
      (.then on-load)
      (.catch on-failure))))

(defn pereodical-dispatch [for to-dispatch interval]
  (when (for)
    (js/setTimeout #(pereodical-dispatch for to-dispatch interval) interval)
    (rf/dispatch to-dispatch)))

(defn dispatch-after [to-dispatch timeout]
  (js/setTimeout #(rf/dispatch to-dispatch) timeout))

(defn deep-merge [a b]
  (merge-with (fn [x y]
                (cond
                  (map? y) (deep-merge x y)
                  (and (vector? y) (every? map? y)) (mapv deep-merge
                                                          (concat (repeat (- (count y) (count x)) {}) x)
                                                          y)
                  :else y))
              a b))