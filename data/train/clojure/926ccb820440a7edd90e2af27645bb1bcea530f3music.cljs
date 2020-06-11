(ns evolute.music)

(defmulti add-to-instrument
  (fn [el _] (first el)))

(defmethod add-to-instrument :note
  [[_ rhythm pitch] instrument]
  (.note instrument (name rhythm) (.toUpperCase (name pitch))))

(defmethod add-to-instrument :rest
  [[_ rhythm] instrument]
  (.rest instrument (name rhythm)))

(defn add-elements
  [instrument song]
  (doall
    (map #(add-to-instrument % instrument) song)))

(defn play-song
  [song & {:keys [volume tempo time-signature]
           :or {volume 100 tempo 180 time-signature [2 2]}}]
  (let [music (js/BandJS.)
        ; instrument (.createInstrument music "square" "oscillators")]
        instrument (.createInstrument music)]
    (doto instrument
      (add-elements song)
      .finish)
    (doto music
      (.setTimeSignature (first time-signature) (second time-signature))
      (.setTempo tempo)
      (.setMasterVolume (/ volume 100))
      .end
      .play)))
