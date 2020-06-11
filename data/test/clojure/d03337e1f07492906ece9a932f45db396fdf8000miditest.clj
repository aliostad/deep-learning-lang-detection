(ns leiningen.test.miditest
    (:require [leiningen.miditest :refer :all]
              [clojure.test :refer :all])
    (:import (javax.sound.midi MidiSystem Sequencer MidiEvent ShortMessage
                               Sequence Track MetaEventListener MetaMessage
                               Instrument)))

(deftest find-instrument-check
  (testing "that nonexisting instrument names return nil"
    (is (= nil (find-instrument "Ocarina of Time")))
    (is (= nil (find-instrument "Pipes of Awakening")))
    (is (= nil (find-instrument "Full Moon Cello")))
    (is (= nil (find-instrument "Organ of Evening Calm"))))
  (testing "that existing instruments return their own instrument"
    (with-open [synth (doto (MidiSystem/getSynthesizer) .open)]
      (is
       (every? true?
               (for [instrument (.getAvailableInstruments synth)]
                 (identical? (find-instrument synth (.getName instrument))
                             instrument)))))))

(deftest all-instruments-check
  (testing "that all instruments listed returns a legal instrument"
    (is (every? #(instance? Instrument (find-instrument %))
                (all-instruments)))))
