(ns sequences.handlers
  (:require [re-frame.core :as re-frame]
            [cljs.core.async :refer [chan timeout]]
            [sequences.synthesis :as syn]
            [leipzig.temperament :as temperament]
            [sequences.db :as db])
  (:require-macros [cljs.core.async.macros :refer [go]]))

;;¯\_(ツ)_/¯
(defn audio-context
  "Construct an audio context in a way that works even if it's prefixed."
  []
  (if js/window.AudioContext. ; Some browsers e.g. Safari don't use the unprefixed version yet.
    (js/window.AudioContext.)
    (js/window.webkitAudioContext.)))
  
(def context (audio-context))

(defn main-loop [control-chan notes-chan]
  (go 
    (while (not= :stop
                 (first (alts! [control-chan notes-chan])))
      (let [note (<! notes-chan)]
        (re-frame/dispatch [:playNote note])))))

(defn play [control-chan notes-chan note speed]
  (go
    (<! (timeout (* (:time note) (/ 1000 speed))))
    (>! control-chan :play)
    (>! notes-chan note)))
  
(defn playNote! [note]
  (let [{:keys [duration instrument]} note
        at (.-currentTime context)
        synth-instance (-> note
                             (update :pitch temperament/equal)
                             (dissoc :time)
                             instrument)
        connected-instance (syn/connect synth-instance syn/destination)]
      (connected-instance context at duration)))

(re-frame/register-handler
  :initialize-db
  (fn  [_ _]
    db/default-db))
  
(re-frame/register-handler
  :playNote
  (fn [db [_, note]]
    (let [notes (:notes db)]
      (playNote! note)
      (merge db {:notes (conj notes note)}))))

(re-frame/register-handler
  :start
  (fn [db [_, notes]]
    (let [speed (:speed db)
          control-chan (chan)
          notes-chan (chan (count notes))]
      (main-loop control-chan notes-chan)
      (doseq [note notes] (play control-chan notes-chan note speed))
      (merge db {:playing? true :notes [] :control-chan control-chan}))))

(re-frame/register-handler
  :stop
  (fn [db _]
    (let [control-chan (:control-chan db)]
      (go (>! control-chan :stop))
      (merge db {:playing? false}))))
    
(re-frame/register-handler
  :updateSpin
  (fn [db [_, spin]]
    (merge db {:spin spin})))
  
(re-frame/register-handler
  :updateSpeed
  (fn [db [_, speed]]
    (merge db {:speed speed})))
      
(re-frame/register-handler
  :updateNotes
  (fn [db [_, notes]]
    (merge db {:notes notes})))
  
(re-frame/register-handler
  :mute
  (fn [db _]
    (let [muted? (:muted? db)
          gain (:gain db)]
      (merge db {:muted? (if muted? false true) :gain (if muted? 0.04 0)}))))