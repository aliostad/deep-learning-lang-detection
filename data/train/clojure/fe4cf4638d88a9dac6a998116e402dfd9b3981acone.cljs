(ns playmary.one
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [goog.dom :as dom]
            [goog.events :as events]
            [cljs.core.async :as async :refer [<! >! chan timeout sliding-buffer map<
                                               onto-chan]]
            [playmary.util :as util]
            [playmary.scales :as scales]))

(def timbre js/T)

(def colors [{:light "#E1B040" :dark "#B9B9B9"}
             {:light "#E18C43" :dark "#999999"}
             {:light "#D35E4C" :dark "#7A7A7A"}
             {:light "#C55D83" :dark "#5C5C5C"}
             {:light "#BB67A2" :dark "#3F3F3F"}
             {:light "#A76AB9" :dark "#272727"}
             {:light "#796DCB" :dark "#000000"}])

(defn prevent-web-view-scrolling
  []
  (set! (.-ontouchmove js/document) (fn [e] (.preventDefault e))))

(defn set-up-web-audio-on-first-touch
  []
  (set! (.-ontouchstart js/document)
        (fn []
          (-> "sin" timbre .play .pause)
          (set! (.-ontouchstart js/document) nil))))

(defn piano-key-width
  [{piano-keys :piano-keys w :w}]
  (.round js/Math (/ w (count piano-keys))))

(defn t->px
  [{start :start px-per-ms :px-per-ms} t]
  (* px-per-ms (- t start)))

(defn note-rect
  [{on :on off :off freq :freq :as note}
   {px-per-ms :px-per-ms playhead :playhead :as instrument}]
  (let [piano-key-w (piano-key-width instrument)]
    {:x (* piano-key-w (get-in instrument [:piano-keys freq :n]))
     :y (+ (t->px instrument on)
           (/ (-> instrument :h) 2))
     :w piano-key-w
     :h (- (t->px instrument (or off playhead))
           (t->px instrument on))}))

(defn screen-rect
  [{w :w h :h playhead :playhead :as instrument}]
  {:x 0 :y (t->px instrument playhead) :w w :h h})

(defn finger-pushing?
  [instrument]
  (not (nil? (-> instrument :scroll :touch-id))))

(defn scrolling?
  [instrument]
  (or (finger-pushing? instrument)
      (not= (-> instrument :scroll :speed) 0)))

(defn draw-note
  [draw-ctx instrument note]
  (let [{x :x y :y w :w h :h} (note-rect note instrument)]
    (set! (.-fillStyle draw-ctx) "#FFFFFF")
    (.fillRect draw-ctx x y w h)))

(defn colliding?
  [r1 r2]
  (not (or (< (+ (:y r1) (:h r1)) (:y r2))
           (> (:y r1) (+ (:y r2) (:h r2))))))

(defn on-screen?
  [instrument note]
  (colliding? (note-rect note instrument)
              (screen-rect instrument)))

(defn draw-notes
  [draw-ctx instrument]
  (doseq [note (filter (partial on-screen? instrument)
                       (-> instrument :notes))]
    (draw-note draw-ctx instrument note)))

(defn draw-piano-keys
  [draw-ctx {w :w h :h playhead :playhead :as instrument}]
  (let [piano-keys (-> instrument :piano-keys)
        piano-key-w (piano-key-width instrument)]
    (doseq [[n [freq piano-key]] (map-indexed vector piano-keys)]
      (set! (.-fillStyle draw-ctx)
            ((if (piano-key :on?) :light :dark) (nth colors (mod n (count colors)))))
      (.fillRect draw-ctx
                 (* n piano-key-w)
                 (t->px instrument playhead)
                 piano-key-w h))))

(defn draw-instrument
  [draw-ctx {w :w h :h playhead :playhead :as instrument}]
  (.save draw-ctx)
  (.translate draw-ctx 0 (-> (t->px instrument playhead) -))
  (.clearRect draw-ctx 0 0 w h)
  (draw-piano-keys draw-ctx instrument)
  (draw-notes draw-ctx instrument)
  (.restore draw-ctx))

(defn touch->piano-key
  [x instrument]
  (let [note-index (.floor js/Math (/ x (piano-key-width instrument)))]
    (nth (-> instrument :piano-keys keys) note-index)))

(defn create-note-synth
  [freq]
  (timbre "adsr"
          (js-obj "a" 5 "d" 10000 "s" 0 "r" 500)
          (timbre "fami" (js-obj "freq" freq "mul" 0.1))))

(defn sound-ready?
  [instrument]
  (not (nil? (-> instrument :piano-keys first second :synth))))

(defn create-instrument
  [scale]
  (let [start (.getTime (js/Date.))]
    {:piano-keys (into (sorted-map) (map-indexed (fn [i freq] [freq {:n i :on? false}])
                                                 scale))
     :notes ()
     :w 0 :h 0
     :sound-on? true
     :px-per-ms 0.3
     :scroll {:speed 0 :friction 0.75 :touch-id nil}
     :start start
     :playhead start}))

(defn add-synths-to-instrument
  [instrument]
  (reduce (fn [a x] (assoc-in a [:piano-keys x :synth] (create-note-synth x)))
          instrument
          (-> instrument :piano-keys keys)))

(defn play-piano-key
  [instrument freq]
  (if (instrument :sound-on?)
    (.play (.bang (get-in instrument [:piano-keys freq :synth])))
    (println "play"))
  (assoc-in instrument [:piano-keys freq :on?] true))

(defn stop-piano-key
  [instrument freq]
  (if (get-in instrument [:piano-keys freq :on?])
    (do
      (if (instrument :sound-on?)
        (.release (get-in instrument [:piano-keys freq :synth]))
        (println "stop"))
      (assoc-in instrument [:piano-keys freq :on?] false))
    instrument))

(defn touch-data->touches [touch-data]
  (let [event (.-event_ touch-data)
        touches (js->clj (.-changedTouches event) :keywordize-keys true)]
    (map (fn [x] {:type (.-type event)
                  :touch-id (:identifier x)
                  :ticks 0
                  :position {:x (:clientX x) :y (:clientY x)}
                  :time (.-timeStamp event)})
         (for [x (range (:length touches))] ((keyword (str x)) touches)))))

(defn touch->freq
  [instrument touch]
  (touch->piano-key (get-in touch [:position :x])
                    instrument))

(defn maybe-init-synths
  [instrument]
  (if (sound-ready? instrument)
    instrument
    (add-synths-to-instrument instrument)))

(defn reduce-val->>
  [f coll val]
  (reduce f val coll))

(defn touch->note
  [{playhead :playhead :as instrument} touch]
  (let [freq (touch->freq instrument touch)]
    (if (not (get-in instrument [:piano-keys freq :on?]))
      {:freq freq
       :on playhead
       :off nil
       :touch-id (touch :touch-id)})))

(defn start-note
  [touch {notes :notes :as instrument}]
  (if-let [new-note (touch->note instrument touch)]
    (-> instrument
        (maybe-init-synths)
        (play-piano-key (new-note :freq))
        (assoc :notes (conj notes new-note)))
    instrument))

(defn end-notes
  [touch {notes :notes playhead :playhead :as instrument}]
  (let [note-off? (fn [n] (= (touch :touch-id) (n :touch-id)))]
    (-> instrument
        (assoc :notes (map (fn [n] (if (note-off? n) (assoc n :off playhead) n)) notes))
        (->> (reduce-val->> stop-piano-key (->> notes (filter note-off?) (map :freq)))))))

(defn distance
  [{x1 :x y1 :y} {x2 :x y2 :y}]
  (.sqrt js/Math (+ (.pow js/Math (- x2 x1) 2) (.pow js/Math (- y2 y1) 2))))

(defn finger-push
  [{touch-id :touch-id touch-y-distance :y-distance} {playhead :playhead :as instrument}]
  (let [speed (/ touch-y-distance (instrument :px-per-ms))]
    (-> instrument
        (assoc-in [:scroll :speed] speed)
        (assoc-in [:scroll :touch-id] touch-id)
        (assoc :playhead (+ playhead speed)))))

(defn stop-finger-push
  [{touch-y-distance :y-distance} instrument]
  (assoc-in instrument [:scroll :touch-id] nil))

(defn stop-scroll
  [touch instrument]
  (assoc-in instrument [:scroll :speed] 0))

(defn inertial-scroll
  [{{speed :speed friction :friction} :scroll
    playhead :playhead px-per-ms :px-per-ms :as instrument}
   delta]
  (if (not (finger-pushing? instrument))
    (let [pre-zeno-speed (* speed friction)
          speed (if (< (.abs js/Math pre-zeno-speed) 1) 0 pre-zeno-speed)]
      (-> instrument
          (assoc :playhead (+ playhead speed))
          (assoc-in [:scroll :speed] speed)))
    instrument))

(defn fire-touch-hold-on-instrument
  [touch instrument]
  (if (scrolling? instrument)
    (stop-scroll touch instrument)
    (start-note touch instrument)))

(defn fire-touch-on-instrument
  [touch instrument]
  (condp = (touch :type)
    "touchstart" (fire-touch-hold-on-instrument touch instrument)
    "touchmove" (finger-push touch instrument)
    "touchend" (->> instrument
                   (end-notes touch)
                   (stop-finger-push touch))))

(defn update-size [instrument canvas-id]
  (let [{w :w h :h :as window-size} (util/get-window-size)]
    (do (util/set-canvas-size! canvas-id window-size)
        (.scrollTo js/window 0 0) ;; Safari leaves window part scrolled down after turn
        (assoc (assoc instrument :h h) :w w))))

(defn touches
  [canvas-id type]
  (map< touch-data->touches (util/listen (dom/getElement canvas-id) type)))

(defn scrolling-touch?
  [touches cur-t]
  (let [prev-t (get touches (cur-t :touch-id))]
    (and prev-t
         (= (cur-t :type) "touchmove")
         (or (= (prev-t :type) "touchmove")
             (and (= (prev-t :type) "touchstart")
                  (> (.abs js/Math (- (-> prev-t :position :y) (-> cur-t :position :y)))
                     10))))))

(defmulti handle-touches (fn [new-touches cur-touches out-c] (-> new-touches first :type)))

(defmethod handle-touches "touchstart"
  [new-touches cur-touches _]
  (go
   (merge cur-touches (zipmap (map :touch-id new-touches) new-touches))))

(defmethod handle-touches "touchmove"
  [new-touches cur-touches out-c]
  (go
   (if-let [scroll (->> new-touches
                        (filter (partial scrolling-touch? cur-touches))
                        (map (fn [{touch-id :touch-id :as t}]
                               (assoc t :y-distance
                                      (- (get-in cur-touches [touch-id :position :y])
                                         (get-in t [:position :y])))))
                        (sort-by :y-distance >)
                        first)]
     (do (>! out-c scroll)
         (assoc cur-touches (scroll :touch-id) scroll))
     cur-touches)))

(defmethod handle-touches "touchend"
  [new-touches cur-touches _]
  (go
   (merge cur-touches (zipmap (map :touch-id new-touches) new-touches))))

(defn emit-touch?
  [{t-type :type t-ticks :ticks} touches]
  (and (or (= t-type "touchstart") (= t-type "touchend"))
       (> t-ticks 0)))

(defn touch-tick
  [touches out-c]
  (let [{emit true keep false} (group-by emit-touch? (vals touches))]
    (go
     (onto-chan out-c (or (vals (select-keys touches (map :touch-id emit))) '()) false)
     (reduce (fn [m k] (update-in m [k :ticks] inc))
             (select-keys touches (map :touch-id keep))
             (map :touch-id keep)))))

(defn touch-chan
  [canvas-id wait]
  (let [out-c (chan)
        c-touchstart (touches canvas-id :touchstart)
        c-touchmove (touches canvas-id :touchmove)
        c-touchend (touches canvas-id :touchend)]
    (go (loop [touches {}]
          (let [[v _] (alts! [c-touchstart c-touchmove c-touchend (timeout wait)])]
            (if (nil? v)
              (recur (<! (touch-tick touches out-c)))
              (recur (<! (handle-touches v touches out-c)))))))
    out-c))

(defn step-time
  [instrument delta]
  (if (scrolling? instrument)
    instrument
    (assoc instrument :playhead (+ (instrument :playhead) delta))))

(defn tick
  [instrument delta]
  (-> instrument
      (step-time delta)
      (inertial-scroll delta)))

(prevent-web-view-scrolling)
(set-up-web-audio-on-first-touch)

(let [canvas-id "canvas"
      frame-delay 16
      c-instrument (chan (sliding-buffer 1))
      c-orientation-change (util/listen js/window :orientation-change)
      c-touch (touch-chan canvas-id frame-delay)]

  (go
   (let [draw-ctx (util/get-ctx canvas-id)]
     (util/set-canvas-size! canvas-id (util/get-window-size))
     (loop [instrument (<! c-instrument)
            timer (timeout frame-delay)]
       (let [[data c] (alts! [c-instrument timer])]
         (condp = c
           c-instrument (recur data timer)
           (do (draw-instrument draw-ctx instrument)
               (recur instrument (timeout frame-delay))))))))

  (go
   (loop [instrument (update-size (create-instrument (scales/c-minor)) canvas-id)]
     (>! c-instrument instrument)
     (let [[data c] (alts! [c-orientation-change c-touch (timeout frame-delay)])]
       (condp = c
         c-orientation-change (recur (update-size instrument canvas-id))
         c-touch (recur (fire-touch-on-instrument data instrument))
         (recur (tick instrument frame-delay)))))))
