(ns jam.events
  (:require [re-frame.core :as re-frame]
            [re-frame.registrar]
            [reagent.core :as reagent]
            [jam.db :as db]
            [jam.logic :as logic]
            [jam.audio :as audio]
            [jam.song :as song]
            [ajax.core :as ajax]
            [jam.ajax]
            [leipzig.scale :refer [D major]]
            [clojure.string]
            [clojure.pprint]
            [hum.core :as hum]))

(re-frame/reg-event-db
 :initialize-db
 (fn  [db _]
   (when (not (nil? (:audio-context db)))
     (.close (:audio-context db)))
   (logic/init-key-handler!) ;;impure
   (doseq [req (db/sound-requests)]
     (re-frame/dispatch req))                       ;; impure
   (-> db/default-db
       audio/init)))

;; Handling of per-frame events

(re-frame/reg-event-db
 :add-tick-handler-ids re-frame/trim-v
 (fn [db [ids]] (update db :tick-handler-ids (fnil into #{}) ids)))

(re-frame/reg-event-db
 :remove-tick-handler-ids re-frame/trim-v
 (fn [db [ids]] (update db :tick-handler-ids #(apply disj % ids))))

(defn re-trigger-timer []
  (reagent/next-tick (fn [] (re-frame/dispatch [:next-tick]))))

(re-frame/reg-event-db
 :next-tick
 (fn [db v]
   (re-trigger-timer)
   (transduce
    (map (partial re-frame.registrar/get-handler :event))
    (completing (fn [db h] (h db v)))
    db (:tick-handler-ids db))))

;; Per-tick handlers

(defn notes-before-time [time notes]
  (count (filter #(>= time (first %)) notes)))

(defn note-diff [db time track]
  (if (empty? (get-in db [:tracks track]))
    []
    (let [played (or (get-in db [:played-notes track]) 0)
          notes (get-in db [:tracks track])
          notes-before (notes-before-time time notes)
          diff (- notes-before played)
          end (+ diff played)
          range (if (< played end) (range played end) (range end played))]
      {:new notes-before :notes (map #(nth notes %) range)})))

(def time-per-tick 0.16)

(defn update-played [db]
  (let [time (:play-time db)
        time-diff (if (= (:state db) :paused) 0 time-per-tick)
        tracks (keys (:tracks db))
        diffs (map (partial note-diff db time) tracks)
        to-play (zipmap tracks (map (comp first :notes) diffs))
        new-played (zipmap tracks (map :new diffs))]
    (doseq [track to-play]
      (let [inst (key track)
            note (second (val track))
            midi (logic/note->midi-locked note D major)
            sample (db/note->sample inst midi)]
        (when (not (nil? note))
          (re-frame/dispatch [:play-sound sample midi]))))
    (-> db
        (assoc :play-time (+ time time-diff))
        (assoc :played-notes new-played))))

(defn update-modulation [db]
  (when (> (:play-time db) 15)
    (doseq [[b rate] (vals (:recent-buffers db))]
      (when (not (nil? b))
        (audio/set-playback-rate b (+ (* 0.1 (Math/sin (* 0.3 (:play-time db)))) rate)))))
  db
  )

(re-frame.registrar/register-handler
 :event
 :tick-child1
 (fn [db _]
   (if (= (:state db) :playing)
     (-> db
         update-played
         update-modulation
         song/update-song)
     db)))

;; Regular handlers

(re-frame/reg-event-db
 :hold-key
 (fn [db _]
   (update db :key-held-frames inc)))

(re-frame/reg-event-db
 :release-key
 (fn [db _]
   (assoc db :key-held-frames 0)))

(re-frame/reg-event-db
 :set-active-panel
 (fn [db [_ active-panel]]
   (assoc db :active-panel active-panel)))

(re-frame/reg-event-db
 :toggle-play
 (fn [db _]
   (update db :state #(if (= % :paused) :playing :paused))))

(re-frame/reg-event-db
 :reset
 (fn [db _]
   (-> db
       (assoc :play-time 0)
       (assoc :state :paused)
       (assoc :tracks (:tracks db/default-db))
       (assoc :song (:song db/default-db)))))

(re-frame/reg-event-db
 :stop
 (fn [db _]
   (-> db
       (assoc :play-time 0)
       (assoc :state :paused))))

(defn parse-sound-name [uri]
  (or (keyword (second (re-find #"sounds/(.+).wav" uri)))
      :crash1))

(re-frame/reg-event-db
 :load-sound-success
 (fn [db [_ result]]
   (let [ctx (:audio-context db)
         response (:response result)
         sound-name ((comp parse-sound-name :uri) result)]
     (audio/make-buffer! ctx response sound-name) ;;impure
     (-> db
         (assoc :show-twirly false)))))

(re-frame/reg-event-db
 :update-sound
 (fn [db [_ result sound]]
   (println (str "Loaded sound " sound" "))
   (-> db
       (assoc :selected-sound (name sound))
       (assoc-in [:sounds sound] result))))


(re-frame/reg-event-db
 :select-instrument
 (fn [db [_ instrument]]
   (assoc db :selected-instrument instrument)))

(re-frame/reg-event-db
 :load-sound-failure
 (fn [db [_ result]]
   (-> db
       (assoc :show-twirly false))))

(defn arraybuffer-response-format []
  {:content-type "audio/wav" :description "WAV file" :read ajax.protocols/-body :type :arraybuffer})

(defn load-sound-request [sound-key]
  {:http-xhrio-uri {:method :get
                    :uri (str "sounds/" (name sound-key) ".wav")
                    :timeout 8000
                    :response-format (arraybuffer-response-format)
                    :on-success [:load-sound-success]
                    :on-failure [:load-sound-failure]}})

(re-frame/reg-event-fx
 :try-load-sound
 (fn [{:keys [db]} [_ sound]]
   (merge
    {:db (assoc db :show-twirly true)}
    (load-sound-request sound))))

(re-frame/reg-event-db
 :keypressed
 ;;after?
 (fn [db [_ e]]
   (let [
         state (:state db)
         selected-instrument (:selected-instrument db)
         [new-db note] (if (= state :playing)
                         (song/play-note db selected-instrument)
                         [db (-> e logic/key-code logic/keycode->note)])
         ;; midi (-> e
         ;;          logic/key-code
         ;;          logic/keycode->note
         ;;          logic/note->midi)
         true-note (if (< (rand 1) 0.40)
                    ;; TODO push back into events? logic?
                    ;; sample name detaches from true midi
                    (logic/similar-note note)
                    note)

         midi (logic/note->midi-locked true-note D major)

         inst (:selected-instrument db)
         sample (db/note->sample inst midi)]
     (when (not= state :playing)
       (re-frame/dispatch [:play-sound sample midi]))
     new-db)))

(re-frame/reg-event-db
 :play-sound
 (fn [db [_ sound-key note]]
   (let [{:keys [audio-context pitch-shift sounds]} db
         sound-buffer ((keyword sound-key) sounds)
         buffer (audio/play-note audio-context pitch-shift sound-buffer note sound-key)]
     (assoc-in db [:recent-buffers sound-key] [buffer (-> buffer .-playbackRate .-value)]))))
