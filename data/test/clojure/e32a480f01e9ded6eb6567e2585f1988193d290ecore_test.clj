(ns aeolian.midi.core-test
  (:use midje.sweet)
  (:require [aeolian.midi.core :as midi]))

(facts "When picking instruments"
       (fact "their ids vary based on filename"
             midi/instruments => (contains (midi/instrument-for "Foo.java"))
             midi/instruments => (contains (midi/instrument-for "Bar.java")))

       (fact "their ids are deterministic based on filename"
             (midi/instrument-for "Foo.java") => (midi/instrument-for "Foo.java"))

       (fact "their ids are different based on filename"
             (midi/instrument-for "Foo.java") =not=> (midi/instrument-for "Bar.java")))
