(ns clooms.state
  (:require [clooms.lights :as lights]
            [clooms.lightcontrol :as control]
            [clooms.db :as db]
            [korma.core :as korma])
  )

(defn find-all-bridges []
  (let [all (korma/select db/bridges)]
    (zipmap (map #(:id %) all) all)
    ))

(def bridge ((find-all-bridges) 1))

;;(def all-lights (ref {"ceiling" (ref{:bridge bridge :group :group_1 :state (ref {})}) "desk" (ref {:bridge bridge :group :group_3 :state (ref {})})}))
;;(def all-lights {"ceiling" {:bridge bridge :group :group_1 :state (ref {})} "desk" {:bridge bridge :group :group_3 :state (ref {})}})

(defn find-all-lights []
  (let [all (korma/select db/lights)
        all-new (map #(assoc % :bridge bridge :state (ref {})) all)]
    (zipmap (map #(:name %) all-new) all-new)
    ))

(def all-lights (find-all-lights))

(defn deref-walk [x] 
  (clojure.walk/prewalk 
   (fn [e] 
     (if (instance? clojure.lang.Ref e) 
       (deref-walk (deref e)) 
       e)) 
   x))

(defn get-all-lights-with-current-state
  []
  "Returns a dereffed list of all lights, including their current states if they are known."
  (deref-walk all-lights)
  )

(defn get-light
  [lightname]
  (deref-walk (all-lights (name lightname))))

(def all-lights (find-all-lights))

(def queue (ref []))

(defn work-on-next-queue-item
  []
  (dosync
   (let [next (first @queue)]
     (if (not (empty? @queue)) (alter queue pop))
     (if (not (nil? next))
       (do
         (apply control/send-command next)
         (Thread/sleep 100)
         )))
   ))

(defn add-to-queue
  [command-tupel]
;  (.start (Thread. (fn [] 
                     (dosync
                      (alter queue conj command-tupel)
                      (while (not (empty? @queue))
                        (work-on-next-queue-item))
                      )
;          ))))
  )

(defn execute
  [bridge group command]
  (do
    (add-to-queue [bridge group command]))
  ;;  (println "QUEUE: "@queue)
  ;;  (work-on-next-queue-item)
  ;;  (println "QUEUE: "@queue)
  )

(defn status
  "Returns the state of a lightgroup."
  [lightname]
  (let [light (all-lights (name lightname))]
    @(:state light)
    ))

(defn property-step
  "Changing either brightness or warmth one step up or down. Managing internal state at the sa
  me time"
  [property lightname increase]
  (dosync 
   (let [shadow-key (keyword (str "shadow-" (name property)))
         property-key (keyword property)
         command (keyword (str (name property) (if increase "_up" "_down")))
         light (all-lights (name lightname))
         state (:state light)
         bridge (:bridge light)
         group (:group light)
         current (property-key @state)
         shadow-property (shadow-key @state)]

     (execute bridge group command)
     (alter state assoc :on true)
     (if (nil? current)
       ;; manage shadow 
       (do
         (if (nil? shadow-property)
           ;; start counting 
           (alter state assoc shadow-key (if increase 1 -1))
           ;; inc or dec shadow brighness, until we reach 10 either side of 0
           (do
             (alter state assoc shadow-key (if increase (inc shadow-property) (dec shadow-property)))
             (let [new-shadow-property (shadow-key @state)] 
               (cond
                (>= new-shadow-property 10) (do
                                              (alter state assoc property-key 10)
                                              (alter state dissoc shadow-key))
                (<= new-shadow-property -10) (do
                                               (alter state assoc property-key 0)
                                               (alter state dissoc shadow-key)
                                               ))))))
       ;; manage real brightness
       (do
         (if (or (and (< current 10) increase) (and (> current 0) (not increase)))
           (alter state assoc property-key (if increase (inc current) (dec current))))
         ))))
  (status lightname))


(defn brightness-step
  "Increase or decrease the brightness of one lightgroup."
  [lightname brighter]
  (property-step :brightness lightname brighter)
  )

(defn brightness-up
  "Increase the brightness of a lightgroup by x steps."
  [lightname steps]
  (dotimes [num steps]
    (brightness-step lightname true)
  )
  (status lightname))

(defn brightness-down
  "Increase the brightness of a lightgroup by x steps."
  [lightname steps]
  (dotimes [num steps]
    (brightness-step lightname false))
  (status lightname))

(defn warmth-step
  "Increase or decrease the warmth of one lightgroup."
  [lightname warmer]
  (property-step :warmth lightname warmer))

(defn warmth-up
  "Increase the warmth of a lightgroup by x steps."
  [lightname steps]
  (dotimes [num steps]
    (warmth-step lightname true))
  (status lightname))

(defn warmth-down
  "Decrease the warmth of a lightgroup by x steps."
  [lightname steps]
  (dotimes [num steps]
    (warmth-step lightname false))
  (status lightname))

(defn nightmode
  "Turn the nightmode on or of for one lightgroup."
  [lightname on]
  (dosync
   (let [light (all-lights (name lightname))
         state (:state light)
         bridge (:bridge light)
         group (:group light)]
     (if on
       (do
         (execute bridge group :nightmode)
         (alter state assoc :on true :nightmode true))
       (do
         (execute bridge group :off)
         (alter state assoc :on false :nightmode false))
       ))))

(defn nightmode-on
  "Turn the nightmode on for a lightgroup."
  [lightname]
  (nightmode lightname true))

(defn nightmode-off
  "Turn the nightmode off for a lightgroup."
  [lightname]
  (nightmode lightname false))

(defn switch-full
  "Switch a lightgroup to full brightness."
  [lightname]
  (dosync
   (let [light (all-lights (name lightname))
         state (:state light)
         bridge (:bridge light)
         group (:group light)]
     (execute bridge group :full)
     (alter state assoc :on true :brightness 10))
   ))

(defn switch
  "Switch a lightgroup on or off."
  [lightname on]
  (dosync
   (let [light (all-lights (name lightname))
         state (:state light)
         bridge (:bridge light)
         group (:group light)]
     (execute bridge group (if on :on :off))
     (alter state assoc :on on :nightmode false)
     )))

(defn switch-off [lightname]
  "Switch off a lightgroup."
  (switch lightname false))

(defn switch-on [lightname]
  "Switch on a lightgroup."
  (switch lightname true))

(defn calibrate
  "Calibrate a lightgroup."
  [lightname]
  (let [light (all-lights (name lightname))
        state (:state light)]
    (if (nil? (:brightness @state))
      (switch-full lightname))
    (if (nil? (:warmth @state))
      (warmth-up lightname 10))
    ))

(defn set-brightness
  "Sets the brightness of a lightgroup to a value."
  [lightname brightness]
  (calibrate lightname)
    (let [light (all-lights (name lightname))
          state (:state light)
          current-brightness (:brightness @state)
          diff (- brightness current-brightness)]
      (if (< diff 0)
        (brightness-down lightname (- diff))
        (if (> diff 0)
          (brightness-up lightname diff)))
      )
    )

(defn set-warmth
  "Sets the brightness of a lightgroup to a value."
  [lightname warmth]
  (calibrate lightname)
  (let [light (all-lights (name lightname))
        state (:state light)
        current-warmth (:warmth @state)
        diff (- warmth current-warmth)]
    (if (< diff 0)
      (warmth-down lightname (- diff))
      (if (> diff 0) (warmth-up lightname diff)))
    )
  )

(defn do-action-on-light
  [light actionname & params]
  (let [action (keyword actionname)]
    (case action
      :switch-on (switch-on light)
      :switch-off (switch-off light)
      :switch-full (switch-full light)
      :set-brightness (set-brightness light (first params))
      :set-warmth (set-warmth light (first params))
      (status light)
      )))








