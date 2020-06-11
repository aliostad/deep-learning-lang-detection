(ns seq26.core
    (:require-macros [cljs.core.async.macros :refer [go alt!]])
    (:require [goog.events :as events]
              [cljs.core.async :as async :refer [put! <! >! chan timeout]]
              [om.core :as om :include-macros true]
              [om.dom :as dom :include-macros true]
              [seq26.hum :as hum]
              [seq26.utils :as util :refer [find-first not-nil? guid]]))

(enable-console-print!)

(defprotocol Instrument
  (-play-at [this midi on-at off-at]))

(def note-names [:C :Db :D :Eb :E :F :Gb :G :Ab :A :Bb :B])

(def keyboard-notes
  (let [start-octave 3
        start-midi (* (inc start-octave) 12)
        notes (for [oct (range start-octave 6)
                    note (map name note-names)]
                [oct note])]
    (mapv (fn [[oct note] i] {:label (str (name note) oct)
                              :midi i
                              :note note
                              :octave oct
                              :color (if (= 2 (count (name note))) "black" "white")}
            ) notes (iterate inc start-midi))))

(def example-song
  (mapv #(assoc % :id (guid))
        [{:midi 69 :beat 0 :length 1}
         {:midi 73 :beat 0.25 :length 1}
         {:midi 76 :beat 0.5 :length 1}
         {:midi 52 :beat 1 :length 0.5}

         {:midi 69 :beat 2 :length 1}
         {:midi 73 :beat 2 :length 1}
         {:midi 76 :beat 2 :length 1}
         {:midi 52 :beat 3 :length 0.5}

         {:midi 69 :beat 4 :length 1}
         {:midi 74 :beat 4.25 :length 1}
         {:midi 76 :beat 4.5 :length 1}
         {:midi 52 :beat 5 :length 0.5}

         {:midi 69 :beat 6 :length 1}
         {:midi 74 :beat 6 :length 1}
         {:midi 76 :beat 6 :length 1}
         {:midi 52 :beat 7 :length 0.5} ]))

(def app-state
  (atom {:params {:bpm 120}
         :playback {:zero-t 0.0
                    :playing? false}
         :sequence example-song }))

(defn add-note! [note]
  (swap! app-state update-in [:sequence] conj note))

(defn select-notes [notes pred]
  (mapv (fn [n]
          (if (pred n)
            (assoc n :selected? true)
            n)) notes))

(defn select-notes! [pred]
  (swap! app-state update-in [:sequence] select-notes pred))

(defn remove-selected [coll]
  (filterv (complement :selected?) coll))

(defn remove-selected! []
  (swap! app-state update-in [:sequence] remove-selected))

(defn- assoc-notes [keys notes]
  (map (fn [k]
         (assoc k :notes (filterv (fn [n]
                                    (= (:midi k) (:midi n))) notes)))
       keys))

;; Audio

(def ctx (hum/create-context))
(def output (hum/create-gain ctx))

(hum/connect-output output)

(hum/set-gain-to output 1.0)

(defn bpm []
  (get-in @app-state [:params :bpm]))

(defn beat->s [b]
  (* (/ 60 (bpm)) b))

(defn s->beats [s]
  (* (/ (bpm) 60) s))

(defn- bare-oscillator [connect-to freq & [type]]
  (let [osc (.createOscillator ctx)]
    (set! (.-value (.-frequency osc)) freq)
    (set! (.-type osc) (or type "sine"))
    (hum/connect osc connect-to)
    (.start osc)
    osc))

(defn oscillator [connect-to freq & [type]]
  (let [gain (hum/create-gain ctx)
        osc (bare-oscillator gain freq type)]
    (hum/connect gain connect-to)
    gain))

(defn bell [connect-to freq]
  (let [harmonic-series [1  2  3   4.2  5.4 6.8]
        proportions     [1 0.6 0.4 0.25 0.2 0.15]
        control (hum/create-gain ctx)
        _ (hum/connect control connect-to)
        component
         (fn [harmonic proportion]
           (let [gain-node (hum/create-gain ctx (* 0.8 proportion))
                 hz (* freq harmonic)
                 osc (bare-oscillator gain-node hz)]
             (hum/connect gain-node control)))]
  (doall (map component harmonic-series proportions))
  control))

(defn on-off-inst
  "Given a map of instrument components (notes, etc), returns an Instrument"
  [notes]
  (reify Instrument
    (-play-at [_ midi on-at off-at]
      (let [note (notes midi)]
        (.setValueAtTime (.-gain note) 0.0 (- on-at 0.001))
        (.linearRampToValueAtTime (.-gain note) 1.0 on-at)
        (.setValueAtTime (.-gain note) 1.0 (- off-at 0.005))
        (.linearRampToValueAtTime (.-gain note) 0.0 (+ off-at 0.005))))))

(defn env-off-inst
  [notes & [decay]]
  (reify Instrument
    (-play-at [_ midi on-at off-at]
      (let [note (notes midi)
            decay (or decay 1.4)] ; length of decay, in seconds
        (.linearRampToValueAtTime (.-gain note) 0.0 (- on-at 0.001))
        (.cancelScheduledValues (.-gain note) on-at)
        (.linearRampToValueAtTime (.-gain note) 1.0 on-at)
        (.linearRampToValueAtTime (.-gain note) 0.8 (+ on-at 0.01))
        (.setValueAtTime (.-gain note) 0.8 off-at)
        (.exponentialRampToValueAtTime (.-gain note) 0.01 (+ off-at decay))
        (.setValueAtTime (.-gain note) 0 (+ off-at decay 0.001))))))

(defn make-inst [instrument-fn midi-notes]
  (let [notes (zipmap midi-notes
                      (map #(instrument-fn output (hum/midi->hz %))
                           midi-notes))]
    (env-off-inst notes)))


(def dejitter-factor (beat->s 1)) ; one beat of dejitter

(defn current-beat [zero]
  (s->beats (- (.-currentTime ctx) zero)))

(defn scheduler
  "Takes an 'instrument'.
  Returns a core/async channel; each message to this channel must be
  a note, and will be scheduled with -play-at
  Notes should be scheduled in order."
  [zero-t inst]
  (let [c (chan 8)]
    (go (loop []
          (when-let [n (<! c)]
            (let [beat (current-beat zero-t)]
              (when (> (- (:beat n) beat) 1) ; when more than a beat ahead (jitter applied)
                (<! (timeout (* 1000 (beat->s 1))))) ; wait for one beat, then proceed
              (let [{:keys [midi beat length]} n
                    from (+ zero-t (beat->s beat))
                    until (+ from (beat->s length))]
                (-play-at inst midi from until))
              (recur)))))
    c))

(defn play
  ([notes]
   (play notes bell))
  ([notes inst-fn]
   (let [notes (sort-by :beat notes)
         inst (make-inst inst-fn (set (map :midi notes)))
         zero-t (+ (.-currentTime ctx) dejitter-factor)
         sch (scheduler zero-t inst)]
     (async/onto-chan sch notes)
     zero-t)))

(defn play! []
  (let [zero-t (play (:sequence @app-state))]
     (swap! app-state update-in [:playback] assoc :zero-t zero-t, :playing? true)))

(defn stop! []
  (swap! app-state assoc-in [:playback :playing?] false))

;; Om components

(defn piano-key [{:keys [octave midi label color note]} owner]
  (reify
    om/IRender
    (render [_]
      (dom/li #js {:className (str color " note-" note)
                   :onClick (fn [e]
                              (.preventDefault e)
                              (select-notes! (fn [n] (= midi (:midi n)))))}
              label))))

(defn note-view [{:keys [beat length selected?] :as note} owner]
  (reify
    om/IRender
    (render [_]
      (dom/div #js {:className (if selected? "selected on" "on")
                    :onClick (fn [e]
                               (.preventDefault e)
                               (.stopPropagation e)
                               (om/update! note [:selected?] (not selected?)))
                    :style #js {:left  (str (/ beat 0.16) "%")
                                :width (str (/ length 0.16) "%")}}
               ""))))

(defn not-nan? [n]
  (not (js/isNaN n)))

(defn- coords [e]
  (let [x 0, y 0, el (.-target e)]
    (loop [x x
           y y
           el el]
      (if (and el (not-nan? (.-offsetLeft el)) (not-nan? (.-offsetTop el)))
        (recur (+ x (- (.-offsetLeft el) (.-scrollLeft el)))
               (+ y (- (.-offsetTop el) (.-scrollTop el)))
               (.-offsetParent el))
        {:x (- (.-clientX e) x) :y (- (.-clientY e) y)}))))

(defn x-percent [e]
  (let [w (.. e -target -offsetWidth)
        {:keys [x]} (coords e)]
    (/ x w)))

(def quantize-factor 4)
(defn quantize [n]
  (/ (Math/round (* quantize-factor n)) quantize-factor))

(defn nearest-beat [e]
  (quantize (* 16 (x-percent e))))

(defn lane-view [{:keys [octave label color note notes midi]} owner]
  (reify
    om/IRender
    (render [_]
      (apply dom/div #js {:className (str color " lane")
                          :onClick (fn [e]
                                     (.preventDefault e)
                                     (add-note! {:midi midi :beat (nearest-beat e) :length 1 :id (guid)}))}
             (apply dom/div #js {:className "notes"}
                    (om/build-all note-view notes {:key :id}))
             (map (fn [i]
                    (dom/div #js {:className "beat-marker"
                                  :style #js {:left (str (/ i 0.16) "%")}}))
                  (range 17))))))

(defn css3-transition
  ([prop duration] (css3-transition prop duration "linear"))
  ([prop duration ease] (css3-transition prop duration ease 0))
  ([prop duration ease del]
   (str prop " " duration "s " ease " " del "s")))

(defn playhead-view [{:keys [zero-t playing?]} owner]
  (reify
    om/IRender
    (render [_]
      (let [bar-s (beat->s 1)]
      (dom/div #js {:className (str "playhead" (when playing? " animate"))
                    :style (when playing? #js {:transition (css3-transition "left" (* 16 bar-s) "linear" (+ 0.02 bar-s))})})))))

(defn seq26-app [app owner]
  (reify
    om/IRender
    (render [_]
      (dom/div nil
        (dom/h1 nil "seq26 is working!")
        (dom/div #js {:id "app"}
          (dom/div #js {:id "pianoroll"}
            (dom/div #js {:id "keys"}
              (apply dom/ul #js {}
                (om/build-all piano-key (reverse keyboard-notes))))
            (apply dom/div #js {:id "lanes"}
                   (om/build playhead-view (:playback app))
                   (om/build-all lane-view
                                 (assoc-notes (reverse keyboard-notes) (:sequence app))))))))))

(om/root seq26-app app-state {:target (.getElementById js/document "content")})

(defn- transform [pred transform-fn item]
  (if (pred item)
    (transform-fn item)
    item))

(defn- f-attr [f attr]
  (fn [item]
    (update-in item [attr] f)))

(let [q (/ 1 quantize-factor)
      up (f-attr inc :midi)
      down (f-attr dec :midi)
      right (f-attr (partial + q) :beat)
      left (f-attr #(- % q) :beat)
      shorten (f-attr #(- % q) :length)
      elongate (f-attr #(+ % q) :length)
      update! (fn [f]
                (swap! app-state update-in [:sequence]
                       #(mapv (partial transform :selected? f) %)))]

  (def keyboard-events
    {32 (fn [e]
          (if (get-in @app-state [:playback :playing?])
            (stop!)
            (play!)))
     37 (fn [e]
          (if (.-shiftKey e)
            (update! shorten)
            (update! left)))
     39 (fn [e]
          (if (.-shiftKey e)
            (update! elongate)
            (update! right)))
     38 (fn [e] (update! up))
     40 (fn [e] (update! down))
     8  (fn [e]
          (.stopPropagation e)
          (remove-selected!))}))

(let [c (chan 1)]
  (go (loop []
        (when-let [event (<! c)]
          (when-let [f (keyboard-events (.-keyCode event))]
            (f event))
          (recur))))
  (.addEventListener js/document "keydown" (fn [e]
                                             (when (keyboard-events (.-keyCode e))
                                               (.preventDefault e))
                                             (put! c e))))

(comment

(deref app-state)
(swap! app-state assoc-in [:params :bpm] 100)

(play!)
(stop!)

)
