(ns nanol33t.app
  (:require [reagent.core :as r]))

(enable-console-print!)

(defonce !global
         (r/atom {:tempo               120
                  :instrument-selected :a
                  :instruments         {:a {:selected-pattern 0
                                            :patterns         [{:pattern-length 16
                                                                :current-step   0
                                                                :pattern        [64 nil nil 64 64 nil nil 64 64 nil nil 64 64 nil nil 64]}]}
                                        :b {:selected-pattern 0
                                             :patterns         [{:pattern-length 16
                                                                 :current-step   0
                                                                 :pattern        [64 nil nil 64 64 nil nil 64 64 nil nil 64 64 nil nil 64]}]}
                                        :c {} :d {} :f {} :g {} :h {}
                                        }}))

(defn note-to-freq [note]
      (* (js/Math.pow 2 (/ (- note 69) 12) ) 440))


(defn pattern-selector []
      [:div
       (for [x (range 10)]
            [:button {:key x} x])])


(defn step-mouse-move [current-pos start-pos index]
  (let [delta (- start-pos current-pos)
        selected-pattern (get-in @!global [:instruments (:instrument-selected @!global) :selected-pattern])]
    (swap! !global (fn [s] (update-in s [:instruments (:instrument-selected @!global) :patterns selected-pattern :pattern index]
                                      #(max (min (- % delta) 127) 0))))))



(defn step-view [index pattern]
      (let [!pressed? (r/atom false)
            !start-pos (r/atom nil)]
           (fn [index pattern]
               (let [selected-instrument (:instrument-selected @!global)
                     selected-pattern (get-in @!global [:instruments selected-instrument :selected-pattern])
                     step (get-in @!global [:instruments selected-instrument :patterns selected-pattern :pattern index])
                     step-colour (if (= (:current-step pattern) index) "grey" "red")]
                    [:button {:class         (if (= (:current-step pattern) index) "current")
                              :style         {:background (str "linear-gradient(180deg, white, white " (dec step) "%, " step-colour " " step "%)")}
                              :on-mouse-move #(if @!pressed? (step-mouse-move (.-pageY %) @!start-pos index))
                              :on-mouse-down #(do (reset! !pressed? true)
                                                  (reset! !start-pos (.-pageY %)))
                              :on-mouse-up   #(reset! !pressed? false)}
                     (if (nil? step) 0 step)]))))


(defn pattern-view []
  (let [selected-instrument (get-in @!global [:instruments (:instrument-selected @!global)])
        selected-pattern    (get-in selected-instrument [:patterns (:selected-pattern selected-instrument)])]
       [:div.pattern-view
        (for [index (range (:pattern-length selected-pattern))]
             ^{:key index} [step-view index selected-pattern])]))


(defn instrument-selector [index instrument-name]
  [:button {:key      index
            :on-click (fn [] (swap! !global #(assoc % :instrument-selected (key instrument-name))))}
   (name (key instrument-name))])

(defn root-component []
  [:div
   [pattern-selector]
   [pattern-view]
   (map-indexed instrument-selector (:instruments @!global))])


(defn advance-step []
  (swap! !global (fn [s] (-> (update-in s [:instruments :a :patterns 0 :current-step] #(if (= % 15) 0 (inc %)))
                             (update-in [:instruments :b :patterns 0 :current-step] #(if (= % 15) 0 (inc %))))))
      (let [a-current-step (get-in @!global [:instruments :a :patterns 0 :current-step])
            a-current-val (get-in @!global [:instruments :a :patterns 0 :pattern a-current-step])
            b-current-step (get-in @!global [:instruments :b :patterns 0 :current-step])
            b-current-val (get-in @!global [:instruments :b :patterns 0 :pattern b-current-step])]

        (if-not (nil? @midi-out) (.forEach @midi-out
                                           (fn([out]
                                                (.send out #js [146 a-current-val 127])
                                                (.send out #js [147 b-current-val 0] (+ (js/performance.now) 100))
                                                (.send out #js [147 b-current-val 127])
                                                (.send out #js [146 a-current-val 0] (+ (js/performance.now) 100))))))))


(defonce bpm (js/setInterval advance-step 400))

(def midi-out (atom nil))

(defn init []
      (.then (js/navigator.requestMIDIAccess)
             (fn [midi-access]
                 (js/console.log midi-access)
                 (reset! midi-out (.-outputs midi-access))
                 ))
  (r/render-component [root-component]
                            (.getElementById js/document "container")))
