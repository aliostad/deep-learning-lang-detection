(ns canverse.loop
  (:require [canverse.synths :as synths]
            [canverse.helpers :as helpers]
            [overtone.core :as o]))

(defn initialize-node [instrument]
  (instrument :amp 0))

(defn create [index history]
  (let [{:keys [notes start-time end-time instrument]} history]
    {
     ; since we no longer care about the time when the loop started, just
     ; the relative offsets of the notes from the start, subtract
     ; the start time from each note's time
     :notes (map #(assoc % :relative-time (- (:relative-time %) start-time)) notes)
     :end-time (- end-time start-time)
     :index index
     :node (initialize-node @synths/current-instrument)
     :current-time 0
     :active? true
     :amp 1

     :instrument @synths/current-instrument}))

(defn get-length [loop]
  (:end-time loop))

(defn restart [time-past-end loop]
  (when (and (not (nil? (:node loop))) (o/node-live? (:node loop)))
    (o/kill (:node loop)))

  (assoc loop
    :node (initialize-node (:instrument loop))
    :current-time time-past-end))

(defn progress [elapsed-time loop]
  (let [{:keys [current-time end-time time-before-start last-start-time]} loop
        new-time (+ current-time elapsed-time)]
    (cond (> new-time end-time)
          (restart (- new-time end-time) loop)

          :else
          (assoc loop
            :current-time new-time))))

(defn get-notes-before-current-time [loop]
  (filter #(<= (:relative-time %) (:current-time loop))
          (:notes loop)))

(defn toggle [loop]
  (assoc loop :active? (not (:active? loop))))

(defn toggle-when-number-pressed [user-input loop]
  (let [last-key-tapped (str (:last-key-tapped user-input))]
    (if (and (not (empty? last-key-tapped))
             (helpers/in-range? (int (:last-key-tapped user-input)) (int \1) (int \9))
             (number? (read-string last-key-tapped))
             (= (dec (read-string last-key-tapped)) (:index loop)))
      (toggle loop)
      loop)))

(defn get-current-note [loop]
  (last (get-notes-before-current-time loop)))

(defn play-current-note! [loop]
  (if (:active? loop)
    (let [current-note (get-current-note loop)]
      (when-not (or (nil? current-note) (not (o/node-live? (:node loop))))
        (o/ctl (:node loop) :amp (* (:amp loop ) (:amp current-note)) :freq (:freq current-note))))
    (o/ctl (:node loop) :amp 0))
  loop)

(defn update! [elapsed-time user-input loop]
  (->> loop
       (progress elapsed-time)
       (toggle-when-number-pressed user-input)
       (play-current-note!)))

; TESTING
(def test-loop (create 0 {:start-time 500 :notes [{:relative-time 800 :amp 0.5 :freq 60} {:relative-time 1000} {:relative-time 1200}]
                        :end-time 1500
                        :instrument synths/oksaw}))
(def after-time-update (progress 400 test-loop))
(get-notes-before-current-time after-time-update)
(get-current-note after-time-update)
