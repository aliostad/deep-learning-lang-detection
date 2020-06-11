;; Macros
;; http://java.ociweb.com/mark/clojure/article.html#Macros

; new constructs in language
; code that generates code at read-time
; manage what is evaluated (for functions - all is evaluated)
; e.g. if cannot be implemented as function - in fact it is special form

; (doc and) dont work in LightTable
((meta (var and)) :macro)
((meta #'and) :macro) ; shorter way

; -> avoid code duplication, when we want control evaluation

(defmacro around-zero [number negative-expr zero-expr positive-expr]
  `(let [number# ~number] ; so number is only evaluated once
     (cond
       (< (Math/abs number#) 1e-15) ~zero-expr
       (pos? number#) ~positive-expr
       true ~negative-expr)))

; Reader expands to let, cond
; number# - auto-gensym: assure that there is only one symbol like that
; -> https://en.wikipedia.org/wiki/Hygienic_macro
; ` - syntax quote, back-quote - prevents all from evaluation
; ~ - unquote
; ~@ - unquote splice list

(around-zero 0.1 (println "-") (println "0") (println "+"))
(println (around-zero 0.1 "-" "0" "+"))

; do - for more than one form
(around-zero 0.1
             (do (log "really cold!") (println "-")) ; log is not defined
             (println "0")
             (println "+"))

(macroexpand-1 '(around-zero 0.1 (println "-") (println "0") (println "+")))
;; (clojure.core/let [number__6002__auto__ 0.1]
;;   (clojure.core/cond
;;     (clojure.core/< (java.lang.Math/abs number__6002__auto__) 1.0E-15) (println "0")
;;     (clojure.core/pos? number__6002__auto__) (println "+")
;;     true (println "-")))

;; function that use macro
(defn number-category [number]
  (around-zero number "negative" "zero" "positive"))

(println (number-category -0.1))
(println (number-category 0))
(println (number-category -0.1))


(defmacro trig-y-category [fn degrees]
  `(let [radians# (Math/toRadians ~degrees)
         result# (~fn radians#)]
     (number-category result#)))

(doseq [angle (range 0 360 60)]
  (println (trig-y-category Math/sin angle)))

(macroexpand-1 '(trig-y-category Math/sin 0))

; macro cannot be pased to e.g. reduce functions
; (reduce and (repeat 3 false))
; workaround: anonymous funtion: (fn [x y] (and x y) or #(and %1 %2)

; macro are processed at read-time