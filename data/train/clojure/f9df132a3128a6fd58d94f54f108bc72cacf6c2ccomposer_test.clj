(ns aeolian.composer-test
  (:use midje.sweet)
  (:require [aeolian.composer :as c]
            [clojure.string :as str]
            [aeolian.abc.tempo :as t]
            [aeolian.abc.notes :as n]
            [aeolian.abc.key :as k]))

(def metric {:source-file "Foo.java" :author "Foo" :complexity 0 :line-length 0 :method-length 1 :indentation? "2" :timestamp 0})

(facts "when processing metrics"
       (fact "a method length metric can be found amongst a collection of metrics"
             (c/find-longest-method-length-in [(dissoc metric :method-length)]) => nil
             (c/find-longest-method-length-in [metric]) => 1
             (c/find-longest-method-length-in [(dissoc metric :method-length) (assoc metric :method-length 3)]) => 3
             (c/find-longest-method-length-in [(assoc metric :method-length 3) (assoc metric :method-length 2)]) => 3
             (c/find-longest-method-length-in [(assoc metric :method-length 3) (dissoc metric :method-length)]) => 3)

       (facts "line length is mapped to note"
              (fact "empty lines are mapped to rests"
                (str/index-of (:notes (c/build-measure [metric] k/major 1)) n/rest-note) => truthy)

              (tabular
               (fact "longer lines are mapped to actual notes with longer lines at higher octaves"
                     ?expected-octave => (contains (c/build-note ?line-length ?composition-key)))
               ?expected-octave    ?line-length  ?composition-key
               n/major-octave-1    9             k/major
               n/major-octave-2    39            k/major
               n/major-octave-3    79            k/major
               n/major-octave-4    99            k/major
               n/major-octave-5    2000          k/major
               n/minor-octave-1    9             k/minor
               n/minor-octave-2    39            k/minor
               n/minor-octave-3    79            k/minor
               n/minor-octave-4    99            k/minor
               n/minor-octave-5    2000          k/minor))

       (facts "when processing git authors"
        (fact "a single author uses the same instrument"
          (let [metrics-for-same-author (c/metrics-to-measure [metric
                                                                (assoc metric :line-length 70)
                                                                (assoc metric :line-length 99)] 
                                                                k/major 1)
                instrument-commands (re-seq #"\[I: MIDI program \d+\]" metrics-for-same-author)]
            (count (distinct instrument-commands)) => 1))

        (fact "multiple authors produces a change in instrument"
          (let [metrics-for-n-authors (c/metrics-to-measure [metric
                                                            metric
                                                                (assoc metric :author "foo")] k/major 1)
                instrument-commands (re-seq #"\[I: MIDI program \d+\]" metrics-for-n-authors)]
            (count (distinct instrument-commands)) => 2)))

       (facts "when processing source files"
        (fact "a single source file uses the same lyric"
          (let [metrics-for-same-file (c/metrics-to-measure [metric
                                                              metric
                                                              metric] k/major 1)
                lyric-commands (re-seq #"w: [\w.]+" metrics-for-same-file)]
            (count (distinct lyric-commands)) => 1))

        (fact "multiple source files produce a change in lyrics"
          (let [metrics-for-same-file (c/metrics-to-measure [(assoc metric :source-file "Foo.java")
                                                              (assoc metric :source-file "Bar.java")
                                                              (assoc metric :source-file "Blech.java")] k/major 1)
                lyric-commands (re-seq #"w: [\w.]+" metrics-for-same-file)]
            (count (distinct lyric-commands)) => 3)))

       (defn- notes-in-measure [metrics]  (first (:notes (c/build-measure [metrics] k/major 1))))

       (fact "complexity > 1 is mapped to tempo"
             (notes-in-measure (assoc metric :complexity 1)) =not=> (contains t/prefix)
             (notes-in-measure (assoc metric :complexity 10)) => (contains t/prefix)
             (notes-in-measure (assoc metric :complexity 5)) => (contains t/prefix)
             (notes-in-measure (assoc metric :complexity 3)) => (contains t/prefix))

       (defn- measure-for [metrics key] (c/metrics-to-measure [metrics] key 1))

       (fact "method-length is mapped to accompanying chord"
             (measure-for (assoc metric :method-length 1) k/major) => (contains "\"C\"")
             (measure-for (assoc metric :method-length 10) k/major) => (contains "\"Dm\"")
             (measure-for (assoc metric :method-length 5) k/minor) => (contains "\"Cm\"")
             (measure-for (assoc metric :method-length 11) k/minor) => (contains "\"_E\"")))

(facts "when opening metrics files"
       (fact "all lines are used in composition"
             (c/compose [metric metric metric] k/minor) => truthy)

       (fact "no metrics means no composition"
             (c/compose [] k/major) => nil))
