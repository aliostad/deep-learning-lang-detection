(ns datalite.id
  "Manage entity ids.")

(def t-bits 42)
(def part-bits 21)

(def max-t (dec (bit-shift-left 1 t-bits)))
(def max-part (dec (bit-shift-left 1 part-bits)))

(def ^:private part-mask (bit-shift-left max-part t-bits))
(def ^:private t-mask (bit-not part-mask))

(defn eid
  "Construct an entity id from part and t."
  [part t]
  (bit-or (bit-and t t-mask)
          (bit-shift-left part t-bits)))

(defn eid->part
  "Return the partition id of eid."
  [eid]
  (bit-shift-right (bit-and eid part-mask) t-bits))

(defn eid->t
  "Returns the t value of eid."
  [eid]
  (bit-or (bit-and (bit-shift-right eid part-bits) part-mask)
          (bit-and eid t-mask)))

