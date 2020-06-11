(ns composition-kit.music-lib.parse-test
  (:use clojure.test) 
  (:require [composition-kit.music-lib.parse :as p])
  (:require [composition-kit.music-lib.logical-sequence :as ls])
  (:require [composition-kit.music-lib.logical-item :as i])
  (:require [composition-kit.music-lib.midi-util :as midi])
  )

(deftest lily-parse  
  (let [parse (p/lily-to-logical-sequence "a4 bes8 r16 a a'4 ges,, ges' ges-")
        by-t  (group-by i/item-type parse)
        notes (:composition-kit.music-lib.logical-item/notes-with-duration by-t)
        rests (:composition-kit.music-lib.logical-item/rest-with-duration by-t)
        ]
    (is (= (count parse) 8))
    (is (= (count notes) 7))
    (is (= (count rests) 1))
    (is (= (flatten (map #(:notes (i/item-payload %)) notes)) '(:a3 :bes3 :a3 :a4 :ges2 :ges3 :ges2)))
    (is (= (map i/item-beat parse) '(0 1 3/2 7/4 2 3 4 5)))
    (is (= (map i/item-beat notes) '(0 1 7/4 2 3 4 5)))
    (is (= (map i/item-beat rests) '(3/2)))
    )
  (let [parse (p/lily-to-logical-sequence "< c  bes'>4. <c bes'>4 <d e>" )]
    (is (= (count parse) 3))
    (is (= (map i/item-beat parse) '(0 3/2 5/2)))
    )

  (let [parse (p/lily-to-logical-sequence "c4 << { d8 e f4 } \\\\ { c4. d} >> c1")]
    (is (= (count parse) 7))
    (is (= (map i/item-beat parse) '(0 1 1 3/2 2 5/2 4)))
    )
  (let [parse 
        (p/lily-to-logical-sequence "a4 b \\tuplet 2/3 { c8 d e } f")]
    (is (= (count parse) 6))
    (is (= (map (i/item-beat parse) '(0 1 2 (+ 2 2/3) (+ 2 4/3) 3))))
    )

  (let [parse
        (p/lily-to-logical-sequence "^hold=1 c4 b ^hold=0.5 d8 e f4")
        parse2
        (p/lily-to-logical-sequence "^hold=0.77 c4 b { d e } << { e f } \\\\ { g a } >> < c e >")]
    (is (= (map (comp :hold-for i/item-payload) parse) [ 1.0 1.0 0.25 0.25 0.5 ]))
    (is (= (distinct  (map (comp :hold-for i/item-payload) parse2)) [0.77]))
    )

  (let [insts
        (-> (midi/midi-instrument-map)
            (midi/add-midi-instrument :ins1    (midi/midi-port 0))
            (midi/add-midi-instrument :ins2    (midi/midi-port 1))
            (midi/add-midi-instrument :ins3    (midi/midi-port 2)))

        parse
        (p/lily-to-logical-sequence "^inst=ins1 c4 d ^inst=ins2 e f ^inst=ins3 g1" :instruments insts)

        ;; And make sure the instrument descends
        parse2
        (p/lily-to-logical-sequence "^inst=ins1 c4 < d e > \\tuplet 2/3 { c8 d e } << { f8 g } \\\\ {a16 b c8 } >> { c1 d1 }" :instruments insts)
        ]
    (is (= (map (comp :name i/item-instrument) parse) [:ins1 :ins1 :ins2 :ins2 :ins3]))
    (is (= (distinct  (map (comp :name i/item-instrument) parse2)) [:ins1]))
    )

  (let [parse
        (p/lily-to-logical-sequence "c8*70 d e*100 f g*30")

        parse2
        (p/lily-to-logical-sequence "c8*70 <d e> \\tuplet 2/3 { c*100 d*60 e } e*100 f")

        parse3
        (p/lily-to-logical-sequence "c8*70 << { c1*20 c*90 } \\\\ { r2 e1*100 f2*70 } >>")

        ]
    (is (= (map i/note-dynamics-to-7-bit-volume parse) [70 70 100 100 30]))
    (is (= (map i/note-dynamics-to-7-bit-volume parse2) [ 70 70 100 60 60 100 100]))
    (is (= (map i/note-dynamics-to-7-bit-volume (filter i/is-notes-with-duration? parse3)) [ 70 20 100 90 70 ]))
    )

  )

(deftest step-parse
  (let [parse (p/str->n :c2 "X...X...X.X.X...")]
    (is (= (count parse) 16))
    (is (= (count (filter #(= (i/item-type %) :composition-kit.music-lib.logical-item/notes-with-duration) parse)) 5))
    (is (= (count (filter #(= (i/item-type %) :composition-kit.music-lib.logical-item/rest-with-duration) parse)) 11))
    (is (= (map i/item-beat (filter #(= (i/item-type %) :composition-kit.music-lib.logical-item/notes-with-duration) parse))
           '(0 1 2 5/2 3)))
    (is (= (map (comp :notes i/item-payload)
                (filter #(= (i/item-type %) :composition-kit.music-lib.logical-item/notes-with-duration) parse))
           (repeat 5 :c2)))
    )
  (let [parse (p/str->n :c2 "azAZ09~~")
        dyn   (map #(% 0) (map i/item-dynamics parse))]
    (is (= dyn '(0 127 0 127 0 127 63 63)))
    )
  )


