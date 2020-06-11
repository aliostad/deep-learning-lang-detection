(ns i3music.core)

(defn example
  "get some example data"
  []
  (slurp "ajax.html"))

;; (def event
;;   {:pulses [{:dom {:str 7, :om 14}
;;              :time 1234
;;              :amplitude 187}
;;             {:dom {:str 3, :om 44}
;;              :time 1500
;;              :amplitude 32}]})

;; (play event)

;; (defn translate-to-sound [position]
;;   {:instrument (get ochestra (:str position))
;;    :stero-delay 0
;;    :tone (get tone (:om position))})

;; (defn translate-to-time [event-time]
;;   (* 0.1 event-time))

;; (defn translate-to-amplitude [pe]
;;   (* 0.256 pe))

;; (defn set-sound [time, sound, amplitude]
;;   )

;; (defn play [event]
;;   (for [pulse (:pulses event)]
;;     (set-sound (translate-to-time (:time pulse))
;;                (translate-to-sound (:dom pulse))
;;                (translate-to-amplitude (:amplitude pulse)))))

