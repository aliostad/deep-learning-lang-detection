(ns composition-kit.music-viz.render-score
  (:require [composition-kit.music-lib.logical-sequence :as ls])
  (:require [composition-kit.music-lib.logical-item :as i])
  (:require [composition-kit.music-lib.tonal-theory :as t])
  (:use clojure.java.shell)
  )

(defn sequence-to-png 
  "Given a sequence, return a filename of a PNG file which renders it"
  [s]
  (let [instruments   (->> s
                           (map (comp :name i/item-instrument))
                           distinct
                           )
        _ (when (not (= (count instruments) 1)) (throw (ex-info "Can only support single instrument renders right now" { :instruments instruments })))

        dirn  (str  (System/getProperty "java.io.tmpdir") "/comp-kit-render-" (System/currentTimeMillis))
        dir (java.io.File. dirn)
        _   (.mkdir dir)
        fn  (java.io.File/createTempFile "comp-kit" ".lytex" dir)
        ]
    ;; so write the file
    (with-open [file (clojure.java.io/writer fn)]
      (binding [*out* file]
        (println "
\\documentclass[a4paper]{article}
\\begin{document}
\\begin{lilypond}
\\absolute {
")
        ;; FIXME - replace this with the LS->lily conversion
        (doall  (for [item s]
                  (case (i/item-type item)
                    :composition-kit.music-lib.logical-item/notes-with-duration
                    (let [p (i/item-payload item)
                          
                          #_pitch-to-abs
                          #_(fn [ nn beats ]
                              (let [n (t/note-by-name nn)
                                    pitch (:pitch n)
                                    oct   (:octave n)

                                    mdur  (/ 4 beats) ;; deal with dots
                                    
                                    res (str (name pitch))
                                    ]

                                )
                              )
                          ]
                      (if (seq? (:notes p))
                        true

                        )
                      )

                    :composition-kit.music-lib.logical-item/rest-with-duration
                    
                    true ;; unhandled case
                    )
                  ))
        ;;(println "\\relative c'' { c4 d e f8 g }")
        (println "
}
\\end{lilypond}
\\end{document}
")
        )
      )
    ;; Now process the file and we have to grunk around in this output looking for the first eps
    (-> (clojure.java.shell/sh "/Applications/LilyPond.app/Contents/Resources/bin/lilypond-book"
                               "-o" dirn
                               (.getPath fn))
        :err
        (clojure.string/split #"\s")
        (as-> li (filter #(clojure.string/includes? % ".eps'") li))
        first
        (as-> li (re-find #"`(.*)'" li))
        second
        (as-> li  (str dirn "/" li))
        (as-> infile
            (clojure.java.shell/sh "convert"
                                   "-background" "white" "-alpha" "remove" 
                                   infile
                                   (str dirn "/result.png"))
          )
        )
    (str dirn "/result.png")
    )
  )

(defn show-png [fn]
  "Given a PNG file name, show it in a window"
  (clojure.java.shell/sh "open" fn)
  )
