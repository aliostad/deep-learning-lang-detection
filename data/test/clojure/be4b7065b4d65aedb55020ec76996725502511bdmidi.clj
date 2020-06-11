(ns music-sorter.midi
  (:require [clojure.java.shell :as shell]
            [clojure.string :as str]
            [music-sorter.util :as util]))

(defn midicsv-available?
  "Return logical true if the midicsv and csvmidi programs are
  available and appear to be working."
  []
  (and (util/sh-succeeds? "midicsv" "-u")
       (util/sh-succeeds? "csvmidi" "-u")))

(defn midi->csv
  [midi & [csv]]
  (util/sh-assert "midicsv" midi (or csv (util/swap-exts midi "mid" "csv"))))

(defn csv->midi
  [csv & [midi]]
  (util/sh-assert "csvmidi" csv (or midi (util/swap-exts csv "csv" "mid"))))

;; Note that we don't try to handle the events that are accompanied by
;; arbitrary binary data.
(def event-table
  {:meta
   {"Title_t" [:title :text]
    "Copyright_t" [:copyright :text]
    "Instrument_name_t" [:instrument-name :text]
    "Marker_t" [:marker :text]
    "Cue_point_t" [:cue-point :text]
    "Lyric_t" [:lyric :text]
    "Text" [:text :text]
    "Sequence_number" [:sequence-number :number]
    "MIDI_port" [:midi-port :number]
    "Channel_prefix" [:channel-prefix :number]
    "Time_signature" [:time-signature :num :denom :click :notes-q]
    "Key_signature" [:key-signature :key [:major-minor {"major" :major
                                                        "minor" :minor}]]
    "Tempo" [:tempo :number]
    "SMPTE_offset" [:smpte-offset :hour :minute :second :frame :frac-frame]

    "Sequencer_specific" :error
    "Unknown_meta_event" :error}
   :channel
   {"Note_on_c" [:note-on :channel :note :velocity]
    "Note_off_c" [:note-off :channel :note :velocity]
    "Pitch_bend_c" [:pitch-bend :channel :value]
    "Control_c" [:control :channel :control-num :value]
    "Program_c" [:program :channel :program-num]
    "Channel_aftertouch_c" [:channel-aftertouch :channel :value]
    "Poly_aftertouch_c" [:poly-aftertouch :channel :note :value]}
   :system-exclusive
   {"System_exclusive" :error
    "System_exclusive_packet" :error}})

(defn csv->data
  [csv]
  (->> csv
    (slurp)
    (str/split-lines)
    (map (fn [line]
           (let [[track time event more] (str/split #", " 4)]
             ;; do things
             )
           (-> line
             (str/split #", " 3))))))
