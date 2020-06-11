(ns composition-kit.music-lib.logical-item)

;; Logical Items are the core thing we assemble in logical sequences. They represent notes, controls, rests, etc.
;; They are described by a set of multimethods which allow them to express their item-ness, "payload" (which is type
;; specific) type, start and end beat, dynamics, instrument, and clock.
;;
;; There is a special item type, the transformer, which allows you to build a chain of functions on any of the characteristics
;; which is how things like time shifts and speedups work.


;; so we start with an item which can be sequenced, defined by a set of multimethods
(defmulti music-item?    :itemtype)
(defmethod music-item? :default [it] false)

(defmulti item-payload   :itemtype)
(defmethod item-payload :default [it] (when (music-item? it) ( :payload-72632 it )))

(defmulti item-beat      :itemtype)
(defmethod item-beat :default [it] (when (music-item? it) ( :beat-2314 it )))

(defmulti item-end-beat   :itemtype)
(defmethod item-end-beat :default [it] (item-beat it))

(defmulti item-type    :itemtype)
(defmethod item-type :default [it] (when (music-item? it) (:itemtype it)))

(defmulti item-has-dynamics? :itemtype)
(defmethod item-has-dynamics? :default [it] nil)

(defmulti item-dynamics :itemtype)
(defmethod item-dynamics :default [it] nil)

(defmulti item-instrument :itemtype)
(defmethod item-instrument :default [it] nil)

(defmulti item-clock :itemtype)
(defmethod item-clock :default [it] nil)

;; We define several types of items; one which has a duration (like a note) and one which is simply at a point
;; in beat (like, say, a dynamics). The note with a duration has a separate dimension of time which is how long
;; it is held for. Since notes can slur, echo, be staccato, be detache and so on, this is a number which
;; when rendered would tell you how much to hold inside the duration.

(defn notes-with-duration
  ([ notes dur beat ] (notes-with-duration notes dur beat 1))
  ([ notes dur beat hold-for]
   {:itemtype ::notes-with-duration
    :payload-72632
    {
     :notes notes
     :dur dur
     :hold-for hold-for
     }
    :beat-2314     beat
    :dynamics-132  (constantly 80)
    })
  )

;; A utility predicate
(defn is-notes-with-duration? [item]
  (= (item-type item) ::notes-with-duration))

(defmethod music-item? ::notes-with-duration [it] true)
(defmethod item-end-beat ::notes-with-duration [it] (+ (:beat-2314 it) (:dur (:payload-72632 it))))
(defmethod item-has-dynamics? ::notes-with-duration [it] true)
(defmethod item-dynamics ::notes-with-duration [it] (:dynamics-132 it))

(defn rest-with-duration [ dur beat ]
  {:itemtype ::rest-with-duration
   :payload-72632 { :dur dur }
   :beat-2314    beat
   })
(defmethod music-item? ::rest-with-duration [it] true)
(defmethod item-end-beat ::rest-with-duration [it] (+ (:beat-2314 it) (:dur (:payload-72632 it))))

(defn music-event [ event beat ]
  {:itemtype ::music-event
   :payload-72632  event
   :beat-2314     beat
   })
(defmethod music-item? ::music-event [it] true)

(defn control-event [ control value beat ]
  {:itemtype ::control-event
   :payload-72632  { :control control :value value }
   :beat-2314     beat
   })
(defmethod music-item? ::control-event [it] true)

(defn sustain-pedal-event [ value beat ] (control-event 64 value beat ))

(defn pitch-bend-event [  value beat ]
  {:itemtype ::pitch-bend-event
   :payload-72632  { :value value }
   :beat-2314     beat
   })
(defmethod music-item? ::pitch-bend-event [it] true)


;; Each item of the transfomer gets handed the entire item.
(defn identity-item-transformer [underlyer]
  {:itemtype ::item-transformer
   :underlyer  underlyer
   :payload-xform  item-payload  ;; under-item -> payload
   :beat-xform     item-beat     ;; under-item -> beat
   :end-beat-xform item-end-beat ;; under-item -> end-beat
   :dynamics-xform item-dynamics ;; under-item -> (wrapped-item -> midi-dynamic)
   :clock-xform    item-clock    ;; under-item -> clock
   :instrument-xform item-instrument ;; under-item -> instrument
   })

(defn add-transform [ transformer type xform ]
  (let [keyw (keyword (str (name type) "-xform"))]
    (if-not (contains? transformer keyw)
      (throw (ex-info (str "Can't assign transformer to unknown slot '" keyw "' (" type ")")
                      {:type type :slot keyw}))
      (assoc transformer keyw xform))
    )
  )

(defmethod music-item? ::item-transformer [it] true);
(defmethod item-beat ::item-transformer [it] ((:beat-xform it) (:underlyer it)))
(defmethod item-end-beat ::item-transformer [it] ((:end-beat-xform it) (:underlyer it)))
(defmethod item-payload ::item-transformer [it] ((:payload-xform it) (:underlyer it)))
(defmethod item-type ::item-transformer [it] (item-type (:underlyer it)))
(defmethod item-has-dynamics? ::item-transformer [it] (item-has-dynamics? (:underlyer it)))
(defmethod item-dynamics ::item-transformer [it]  ((:dynamics-xform it) (:underlyer it)))
(defmethod item-clock ::item-transformer [it] ((:clock-xform it) (:underlyer it)))
(defmethod item-instrument ::item-transformer [it] ((:instrument-xform it) (:underlyer it)))


;; Dynamics
(defn note-dynamics-to-7-bit-volume [item]
  (when (item-has-dynamics? item)
    ((item-dynamics item) item)))


(defn override-dynamics [item f]
  "A function of one argument (the item) becomes the new dynamics function.
Note if this function calls note-dynamics-to-7-bit-volume it will recur infinitely
since it comes back to the dynamics. If you want that, use compose-dynamics"
  (add-transform (identity-item-transformer item) :dynamics (constantly f)))

(defn compose-dynamics [item f]
  "A function of two arguments (the item and the dynamics of the underlyer) becomes
the new dynamics function. For instance

  (compose-dynamics note (fn [n d] (min 127 (+5 d))))

makes your note louder. (There's a utility function for that below though)"
  (add-transform
   (identity-item-transformer item)
   :dynamics
   (fn [outer]
     (fn [a]
       (f a (note-dynamics-to-7-bit-volume outer))))
   ))

(defn louder-by [item a]
  (compose-dynamics item (fn [n d] (min 127 (+ a d)))))

(defn softer-by [item a]
  (compose-dynamics item (fn [n d] (min 127 (- d a)))))

(defn amplify-by [item a]
  (compose-dynamics item (fn [n d] (min 127 (* d a)))))

(defn constant-dynamics [item val] (override-dynamics item (constantly val)))

(defn item-beat-shift [ it shift ]
  (-> (identity-item-transformer it)
      (add-transform :beat (comp (partial + shift) item-beat))
      (add-transform :end-beat (comp (partial + shift) item-end-beat))))

