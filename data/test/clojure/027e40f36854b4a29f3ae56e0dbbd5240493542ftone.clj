;; #(over)tone
;; Leverages Overtone to actuate sound on triggers from wearable sensor events.
;;
(ns sound.tone
  (:require [clojure.core.async :as a :refer [<! go-loop]]
            [sound.comm :as comm]
            [overtone.core :refer :all]
            [overtone.synth.stringed :refer :all]
            [overtone.synth.sts :refer :all]
            [overtone.at-at :as at]
            [clojure.pprint :refer [pprint]]))

(defonce sc-server (boot-internal-server))

(def instrument (atom {:current :pariacaca}))

;; ## Sample Sampled Instruments
;; ### Guitar Pluck

(defonce bs5 (load-sample "assets/ws_two/Yacana/Short/Frog 2.wav"))
(definst play-bs5 [amp 1]
         (* amp (play-buf 1 bs5)))
(def static-bs5 (partial play-bs5 :amp 0.3))

(defonce bs6 (load-sample "assets/ws_two/Yacana/Short/Frog 3.wav"))
(definst play-bs6 [amp 1]
         (* amp (play-buf 1 bs6)))
(def static-bs6 (partial play-bs6 :amp 0.3))

(defonce bs8 (load-sample "assets/ws_two/Yacana/Short/Scissors 1.wav"))
(definst play-bs8 [amp 1]
         (* (play-buf 1 bs8) amp))
(def static-bs8 (partial play-bs8 :amp 0.3))

(defonce bs9 (load-sample "assets/ws_two/Birth of Pariacaca/Short/Siku 4.wav"))
(definst play-bs9 [amp 1]
         (* (play-buf 1 bs9) amp))
(def static-bs9 (partial play-bs9 :amp 0.3))


(defonce bs10 (load-sample "assets/ws_two/Birth of Pariacaca/Short/Siku 6.wav"))
(definst play-bs10 [amp 1]
         (* (play-buf 1 bs10) amp))
(def static-bs10 (partial play-bs10 :amp 0.3))


;; ## Sound Helpers

(defn playat [time delta offset]
  (+ time (* offset delta)))

;; ## Axis based guitar trigger.

;; ### Guitars

(def lg-guitar (guitar))
(def md-guitar (guitar))
(def sm-guitar (guitar))

(defmulti axis-trigger
          "Triggers sub-methods when on a *large*, *medium*, or *small* change in device axis data happens."
          :action)

;; #### Large

(defmethod axis-trigger :large [msg]
  (case (:sensor msg)
    :x (static-bs9)
    :y (guitar-pick lg-guitar 3 5)
    :z (guitar-pick lg-guitar 1 3)))

;; #### Medium

(defmethod axis-trigger :medium [msg]
  (case (:sensor msg)
    :x (static-bs10)
    :y (guitar-pick md-guitar 3 5)
    :z (guitar-pick md-guitar 1 3)))

;; #### Small

(defmethod axis-trigger :small [msg]
  (case (:sensor msg)
    :x (static-bs5)
    :y (static-bs6)
    :z (static-bs8)))

;; October 2015 Workshop

(defonce pariacaca-long-joel&ronald (load-sample "assets/ws_two/Yacana/Long Tracks/Blue Beans Buenos Aires Wrkshp.wav"))
(defonce pariacaca-long-polar-wind (load-sample "assets/ws_two/Yacana/Long Tracks/Earthquake Rumble.wav"))
(defonce pariacaca-long-rain (load-sample "assets/ws_two/Yacana/Long Tracks/Water Stream.wav"))

(definst pariacaca [vola 1 volb 0 volc 0]
         (let [a (* (* volb 3) (play-buf :num-channels 1 :bufnum pariacaca-long-joel&ronald :loop 1))
               b (* (* volb 3) (play-buf :num-channels 1 :bufnum pariacaca-long-polar-wind :loop 1))
               c (* (* volc 3) (play-buf :num-channels 1 :bufnum pariacaca-long-rain :loop 1))]
           (mix [a b c])))

(defonce masoma-long-flies (load-sample "assets/ws_two/Yacana/Medium/pinkuillo 1.wav"))
(defonce masoma-long-omar&joel (load-sample "assets/ws_two/Yacana/Medium/pinkuillo 3.wav"))
(defonce masoma-long-quechua (load-sample "assets/ws_two/Yacana/Medium/pinkuillo 6.wav"))

(definst masoma [vola 1 volb 0 volc 0]
         (let [a (* (* volb 1) (play-buf :num-channels 1 :bufnum masoma-long-flies :loop 1))
               b (* (* volb 1) (play-buf :num-channels 1 :bufnum masoma-long-omar&joel :loop 1))
               c (* (* volc 1) (play-buf :num-channels 1 :bufnum masoma-long-quechua :loop 1))]
           (mix [a b c])))

(defonce yacana-long-blue-beans (load-sample "assets/ws_two/Yacana/Long Tracks/Blue Beans Buenos Aires Wrkshp.wav"))
(defonce yacana-earthquake (load-sample "assets/ws_two/Yacana/Long Tracks/Earthquake Rumble.wav"))
(defonce yacana-water-stream (load-sample "assets/ws_two/Masoma/Long Tracks/Quechua text read out loud.wav"))

(definst yacana [vola 1 volb 0 volc 0]
         (let [a (* (* volb 2) (play-buf :num-channels 1 :bufnum yacana-long-blue-beans :loop 1))
               b (* (* volb 2) (play-buf :num-channels 1 :bufnum yacana-earthquake :loop 1))
               c (* (* volc 2) (play-buf :num-channels 1 :bufnum yacana-water-stream :loop 1))]
           (mix [a b c])))

;; To-Do, cleaner cuts.

(defmulti sample-blend
          "Control (ctl) specific sample-blend instruments. Allows for constantly running background sounds."
          :action)

(defmethod sample-blend :pariacaca [msg]
  (let [[_ vola _ volb _ volc] (:data msg)]
    (ctl pariacaca :vola (if (nil? vola) 0 vola) :volb (if (nil? volb) 0 volb) :volc (if (nil? volc) 0 volc))))

(defmethod sample-blend :masoma [msg]
  (let [[_ vola _ volb _ volc] (:data msg)]
    (ctl masoma :vola (if (nil? vola) 0 vola) :volb (if (nil? volb) 0 volb) :volc (if (nil? volc) 0 volc))))

(defmethod sample-blend :yacana [msg]
  (let [[_ vola _ volb _ volc] (:data msg)]
    (ctl yacana :vola (if (nil? vola) 0 vola) :volb (if (nil? volb) 0 volb) :volc (if (nil? volc) 0 volc))))

(defn ctl-current [msg]
  (let [[_ vola _ volb _ volc] (:data msg)]
    (case (:current @instrument)
      :yacana (ctl yacana :vola (if (nil? vola) 0 vola) :volb (if (nil? volb) 0 volb) :volc (if (nil? volc) 0 volc))
      :masoma (ctl masoma :vola (if (nil? vola) 0 vola) :volb (if (nil? volb) 0 volb) :volc (if (nil? volc) 0 volc))
      :pariacaca (ctl pariacaca :vola (if (nil? vola) 0 vola) :volb (if (nil? volb) 0 volb) :volc (if (nil? volc) 0 volc)))))

;; ## Event distributor

(defmulti control
          "Distributes, to appropriate sound generators, various trigger events from q/comm"
          :topic)

(defmethod control :axis-trigger [{:keys [msg]}]
  (axis-trigger msg))

(defmethod control :sample-blend [{:keys [msg]}]
  (sample-blend msg))

(defmethod control :change-inst [{:keys [msg]}]
  (println msg)
  (if (= :thunder-storm (:current @instrument))
    (do (reset! instrument {:current :fire-fly})
        #_(ctl storm :vola 0 :volb 0 :volc 0))
    (do (reset! instrument {:current :thunder-storm})
        #_(ctl fly-fire :vola 0 :volb 0 :volc 0))))

(defn init
  "Sets instruments to their initial state, starts listening for events."
  []
  (ctl lg-guitar :pre-amp 5 :distort 0.14 :noise-amp 0.82
       :lp-freq 3400 :lp-rq 4.5
       :rvb-mix 0.01 :rvb-room 0.01 :rvb-damp 0.5)

  (ctl md-guitar :pre-amp 5 :distort 0.12 :noise-amp 0.82
       :lp-freq 3400 :lp-rq 2.5
       :rvb-mix 0.01 :rvb-room 0.01 :rvb-damp 0.5)

  (ctl sm-guitar :pre-amp 5 :distort 0.10 :noise-amp 0.82
       :lp-freq 3400 :lp-rq 1.5
       :rvb-mix 0.01 :rvb-room 0.01 :rvb-damp 0.5)

  (pariacaca)
  (masoma)
  (yacana)

  (ctl pariacaca :vola 0 :volb 0 :volc 0)
  (ctl masoma :vola 0 :volb 0 :volc 0)
  (ctl yacana :vola 0 :volb 0 :volc 0)

  (go-loop []
    (when-let [v (<! comm/adjust-tone)]
      (control v)
      (recur))))