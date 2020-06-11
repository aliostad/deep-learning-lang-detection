(ns music-score.abc)

(defonce *instrument* (js/Instrument. #js {:wave "piano" :detune 0}))

(defn add-clef [clef abc-str]
  (if (= clef :bass)
    (str "K:bass\n" abc-str)
    abc-str))

(defn midi-to-abc [midi]
  (Instrument.midiToPitch midi))

(defn midi-to-abc-string [midi clef]
  (->> midi
    (map midi-to-abc)
    (apply str)
    (add-clef clef)))

(defn midis-to-abc [midis]
  (->> midis
       (map midi-to-abc)
       (into [])))


(defn render-abc [abc node]
  (js/ABCJS.renderAbc node abc #js {} #js {:add_classes true}))

(defn render-abc-id [abc id]
  (render-abc abc (. js/document getElementById id)))

(defn play-abc [abc]
  (let [inst *instrument*]
    (.play inst abc)))

(defn parse-abc-file [abc-str]
  (js/parseABCFile abc-str))

(defn extract-freq [tones]
  (let [stems (-> tones
                  (aget "voice")
                  (aget "")
                  (aget "stems")
                  )
        freqs (reduce (fn [acc stem]
                        (conj acc (reduce (fn [acc note]
                                            (conj acc (note "frequency")))
                                          #{} (stem "notes"))))
                      [] (js->clj stems))
        ]
    (print freqs)
    freqs))

(defn midi-to-freq [midis]
  (as-> midis _
        (map midi-to-abc _)
        (apply str _)
        (parse-abc-file _)
        (extract-freq _)))