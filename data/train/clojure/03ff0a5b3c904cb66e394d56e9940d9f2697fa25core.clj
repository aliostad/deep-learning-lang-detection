(ns junior.core)

(defmacro ?else [x else] `(if ~x ~x ~else))
(defn !nil? [x] (not (nil? x)))
(defmacro !nil?else [x else] `(if (!nil? ~x) ~x ~else))
(defmacro if= [x y then else] `(if (= ~x ~y) ~then ~else))

(defn
  ^{:doc "Creates a MapEntry"}
  map-entry ([x y] (map-entry [x y]))([coll]
  (if= 2 (count coll)
       (clojure.lang.MapEntry. (first coll) (second coll))
       (throw (Exception. "CardinallityException in map-entry: Wrong number of elements in collection, must be of size 2")))))

(defn append [coll x]
  (if (or (seq? coll) (list? coll))
    (apply conj (conj (empty coll) x) (reverse coll))
    (conj coll x)))


(defn
  ^{:doc "Like clojure.walk/walk but preserves metadata on lists.
Traverses form, an arbitrary data structure.  inner and outer are
  functions.  Applies inner to each element of form, building up a
  data structure of the same type, then applies outer to the result.
  Recognizes all Clojure data structures. Consumes seqs as with doall.
NOTE: This code was forked from
https://github.com/clojure/clojure/blob/master/src/clj/clojure/walk.clj
commit 2224dba"}
  walk4pre
  [inner outer form]
  (cond
   (list? form) (with-meta (outer (apply list (map inner form) )) (meta form))
   ;(list? form) (outer (apply list (map inner form) ))
   (instance? clojure.lang.IMapEntry form) (outer (map-entry (map inner form)))
   (seq? form) (outer (doall (map inner form)))
   (instance? clojure.lang.IRecord form)
     (outer (reduce (fn [r x] (conj r (inner x))) form form))
   (coll? form) (outer (into (empty form) (map inner form)))
   :else (outer form)))

(defn
  ^{:doc "Like clojure.walk/prewalk but preserves metadata on lists.
Like postwalk, but does pre-order traversal.
NOTE: This code was forked from
https://github.com/clojure/clojure/blob/master/src/clj/clojure/walk.clj
commit 2224dba"}
  prewalk
  [f form]
  (walk4pre (partial prewalk f) identity (f form)))

(defn
  ^{:doc "Like clojure.walk/walk but
also takes the map-entry intead of vec in the IMapEntry cond.
Traverses form, an arbitrary data structure.  inner and outer are
  functions.  Applies inner to each element of form, building up a
  data structure of the same type, then applies outer to the result.
  Recognizes all Clojure data structures. Consumes seqs as with doall.
NOTE: This code was forked from
https://github.com/clojure/clojure/blob/master/src/clj/clojure/walk.clj
commit 2224dba"}
  walk4post
  [inner outer form]
  (cond
   (list? form) (outer (apply list (map inner form) ))
   (instance? clojure.lang.IMapEntry form) (outer (map-entry (map inner form)))
   (seq? form) (outer (doall (map inner form)))
   (instance? clojure.lang.IRecord form)
     (outer (reduce (fn [r x] (conj r (inner x))) form form))
   (coll? form) (outer (into (empty form) (map inner form)))
   :else (outer form)))

(defn postwalk
  "Performs a depth-first, post-order traversal of form.  Calls f on
  each sub-form, uses f's return value in place of the original.
  Recognizes all Clojure data structures. Consumes seqs as with doall."
  {:added "1.1"}
  [f form]
  (walk4post (partial postwalk f) f form))

(defn do0 [& c]
  (last (map #(apply (first %) (next %)) c)))



(defn transform0 [m x]
  (if (coll? x)
    (walk4pre #(!nil?else (m %) %) identity x)
    (!nil?else (m x) x))
  )
(defn flat0 [m c]
  (loop [in- c out- (empty c)]
    (let [f (first in-) tr (transform0 m f)]
      (if (!nil? tr)
        (recur (next in-) (apply conj out- (if (list? tr) tr [tr])))
        out-))))

(defn
  ^{:doc " Deprecated.
If f is a symbol returns (map- f) if not nil, else f
If f is a vector with count > 1, if not nil apply'es (map- f) to (next f), else f.
Otherwise returns the map of the first f if not nil, else f.
Usage:
(abstract {'plus +} ['plus 1 2])
;=> 3
((abstract {'plus +} ['plus]) 1 2)
;=> 3
((abstract {'plus +} 'plus) 1 2)
;=> 3"}
  abs0- [map- f]
  (cond (not (coll? f)) (!nil?else (map- f) f)
        (!nil? (map- (first f))) (if (next f)
                                   (if (and (meta (second f)) (:abs-args (meta (second f))))
                                     (apply (map- (first f))
                                            (into (second f)
                                                  (walk4pre #(!nil?else (map- %) %) identity (next (next f)))))
                                         
                                   
                                     (apply (map- (first f))
                                            (walk4pre #(!nil?else (map- %) %) identity (next f))))
                                   ((map- (first f))))
        :else (if (next f)
                (if (and (meta (second f)) (:abs-args (meta (second f))))
                  (apply (first f)
                         (into (second f)
                               (walk4pre #(!nil?else (map- %) %) identity (next (next f)))))
                  (apply (first f) 
                         (walk4pre #(!nil?else (map- %) %) identity (next f))))
                ((first f)))))

(defn
  ^{:doc "basic features:
(abs0 {the map} ['(args to flatten) 'arg1 'arg2 '(more args)])
no nested vectors.
(abs0 {'s str 'a \"a\" 'b :b 'c 'c 'd '(\"d\" {\"e\" \"f\"})}
      ['(s a) '(b c) 'd])
;=> a:bcd{\"e\" \"f\"}"}
  abs0 [m f]
  (let [fl (flat0 m f)](apply (first fl) (next fl))))

(defn
  ^{:doc "postwalks f applying abs0 to each vector"}
  fabs0 [map- & f]
  ;(prn f)
  (last (map #(postwalk
               (fn [x] (if (and (coll? x) (and (not (map-entry? x)) (not (map? x))))
                 (abs0 map- x)
                 x)) %) f))
  )

(defn resolve1 [sm x]
  ;(prn (type x) x)
  (loop [sm sm]
    (if (first sm)
      (if (map-entry? x)
        (if (!nil? ((first sm) (second x)))
          (map-entry (first x) ((first sm) (second x))) (recur (next sm)))
        (!nil?else ((first sm) x) (recur (next sm))))
      nil)))

(defn transform1 [sm x]
  (if (coll? x)
    (walk4pre #(!nil?else (resolve1 sm %) %) identity x)
    (!nil?else (resolve1 sm x) x))
  )

(defn flat1 [sm c]
  (loop [in- c out- []]
    (let [f (first in-)
          vec? (vector? f)
          tr (if vec? nil (transform1 sm f))]
      (if vec? (recur (rest in-) (apply conj out- [f]))
        (if (!nil? tr)
          (do (prn 'tr '_ tr (type tr))(recur (rest in-) (apply conj out- (if (or (list? tr) (instance? clojure.lang.LazySeq tr)) (into [] tr) [tr]))))
          out-)))))
(declare abs1)
(defn apply1 [sm f]
  (prn "sm " sm)
  (prn "f " f)
  (apply (if (symbol? (first f)) (resolve (first f)) (first f)) (map #(if (vector? %) (abs1 sm %) %) (rest f)))
  )

(defn
  ^{:doc "like abs0 but accepts deep nested vectors.
the map can be optionally the first argument. If the first
argument points to a map, then its appended to the map chain.
There is a map chain, a sequence like ({last map} {older map}...).
(abs1 (seq [{:a +}]) [+ 2 [{:a 1 :b 2} + :a :b]])
;=> 5
(abs1 (seq [{:a {:b + :c '(1 1)} :b +}]) [:a :b :c])
;=> 2"}
  abs1 ([f] (abs1 {} f))([sm f]
  (let [m (if (map? (first f)) (first f))
        mr (if m (transform1 sm m))
        sm2 (if m (cons mr sm) sm)
        fl (if m (flat1 sm2 (rest f)) (flat1 sm2 f))
        m2 (if (map? (first fl)) (first fl))
        mr2 (if m2 (transform1 sm2 m2))
        sm3 (if m2 (cons mr2 sm2) sm2)
        fl2 (if m2 (flat1 sm3 (rest fl)) (flat1 sm3 fl))]
    ;(prn fl2)
    (apply1 sm3 fl2))))

(defn literal? [x]
  (or (instance? clojure.lang.Keyword x)
      (instance? java.lang.Integer x)
      (instance? java.lang.Boolean x)
      (instance? java.lang.String x)
      (instance? java.lang.Long x)
      (instance? java.lang.Float x)
      (instance? java.lang.Character x)
      (instance? java.lang.Double x)
      (instance? java.lang.Byte x)
      (instance? java.lang.Short x)
      (instance? java.math.BigInteger x)
      (instance? java.math.BigDecimal x)
      (instance? clojure.lang.Ratio x)))

(defn vector-type2 [v]
  (let [m (meta v)]
    (cond (nil? m) :c
          (:abs m) (if (keyword? (:abs m))
                     (:abs m)
                     (throw (Exception. (str "NotKeywordException. vector-type: ^" m v " :abs meta key must map to a keyword. Ex. {:abs :some-vector-handler}, in this case you have to have a function like (defn some-vector-handler [sm f]...)."))))
          (> (count m) 1) (throw (Exception. (str "UndecidableException. vector-type: ^" m v " has more than one meta key.")))
          :else (key (first m)))))

(defn map-type2 [v]
  (let [m (meta v)]
    (cond (nil? m) :l
          (:abs m) (if (keyword? (:abs m))
                     (:abs m)
                     (throw (Exception. (str "NotKeywordException. map-type: ^" m v " :abs meta key must map to a keyword."))))
          (> (count m) 1) (throw (Exception. (str "UndecidableException. map-type: ^" m v " has more than one meta key.")))
          :else (key (first m)))))

(defn
  ^{:doc "resolves the var in the name of keyword k. Ex :str -> #'clojure.core/str"}
  resolve-keyword [k]
  (resolve (symbol (name k))))

(defn single-meta-key-resolve [f]
  (let [m (meta f)
        abs (if m (:abs m) nil)
        m2 (if abs (map-entry abs true)
             (if (> (count m) 1)
               nil;(throw (Exception. (str "single-meta-key-resolve " f " has more than one meta key. " m)))
               (first m)))
        ;pp (if (> (count m) 1) (throw (Exception. (str "single-meta-key-resolve " f " has more than one meta key. " m))))
        ;fi (first (meta f))
        ]
  (if m2 (resolve (symbol (subs (str (key m2)) 1))) nil)
  ))

(declare transform2)

(defn m [sm mp]
  ;(prn mp)
  (transform2 sm mp)
  )

(defn v [sm v]
  (transform2 sm v)
  )

(declare resolve2)

(defn transform2 [sm x]
  ;(prn 'sm sm)
  (prn 'transforming x)
  (if (coll? x)
    #_(postwalk #(if (coll? %) % (let [res (resolve2 sm %)] (if res (res %) %))) x)
    (postwalk #(let [res (resolve2 sm %)] (if res (res %) %)) x)
    (let [res (resolve2 sm x)] (if (!nil?  res) (res x) x)))
  )

(declare abs2)

(defn
  ^{:doc "Named transformlet2."}
  l [sm m]
  ;(prn m)
  (loop [sm sm m m]
    (let [f (first m)
          ff (first f)
          fv (if (vector? ff) (abs2 sm ff) ff)]
      (if f
        (let [sec (second f)]
            (cond (vector? sec) (let [abs (abs2 sm (second f))
                                      sm2 (cons {fv abs} sm)]
                                  (recur sm2 (rest m)))
                  (map? sec) (let [sr (single-meta-key-resolve sec)]
                                   (if sr (let [sr-res (sr sm sec)
                                                sm2 (cons {fv sr-res} sm)]
                                            (recur sm2 (rest m)))
                                     (let [tr (transform2 sm sec) sm2 (cons {fv tr} sm)]
                                       (recur sm2 (rest m)))))
                  (or (keyword? sec) (symbol? sec)) (let [res (resolve2 sm sec)
                                                          sec-res (if res (sec res) sec)
                                                          sm2 (cons {fv sec-res} sm)]
                                                      (recur sm2 (rest m)))
                  :else (let [tr (transform2 sm sec) sm2 (cons {fv tr} sm)]
                          (recur sm2 (rest m)))))
        sm))))

(defn sm-add2 [sm m]
  (apply conj [m] sm)
  )
(defn flat2 [sm c]
  (loop [in- c out- (empty c)]
    (if (!nil? (first in-))
      (let [f (first in-)
            tr (if (or (list? f) (instance? clojure.lang.LazySeq f))
                 (into [] f)
                 [f])]
        (recur (rest in-) (apply conj out- tr)))
      out-)))

(defn resolve2 [sm x]
  (loop [sm sm]
    (if (first sm)
      (if (map-entry? x)
        (if (!nil? ((first sm) (second x)))
          (map-entry (first x) ((first sm) (second x))) (recur (rest sm)))
        (if (!nil? ((first sm) x)) {x ((first sm) x)} (recur (rest sm))))
      nil)))

(defn apply2 [sm f]
  (let [;fapp (resolve2 sm f)
        tr (transform2 sm f)]
    ;(prn 'trd (type tr) tr #_(apply (first f) (rest f)))
    (apply (first tr) (rest tr)))
  )

#_(defn apply2 [sm f s]
   (let [fapp (resolve2 sm f)
         tr (transform2 sm s)]
     (prn 'trd (type tr) tr (apply fapp tr))
     (apply fapp tr))
   )


(defn
  ^{:doc "Named call2"}
  c [sm f]
  (loop [sm sm f- f last- nil]
    (let [fi (first f-)]
      (if (!nil? fi)
        (cond (map? fi)(let [sr (single-meta-key-resolve fi)
                             tr (!nil?else sr l)
                             sm2 (tr sm fi)]
                         (recur sm2 (rest f-) (second (ffirst sm2))))
              (vector? fi) (if (!nil? (next f-))
                             (let [app (apply2 sm (cons (second f-) fi))]
                               app)
                             (throw (Exception. (str "No function to apply to " fi ":" f))))
              (or (symbol? fi) (keyword? fi)) (apply2 sm f-)
              :esle (apply2 sm f-))
        last-))))

(defn
  ^{:doc "Main vector handler. Redirects the thread for ^:*[] vectors.
Every handler should redirect to abs2 when unknown vector.
Vector knowledges:
^:do[] - main thread.
[] or ^:c[] - main call.

"}
  abs2 ([f] (abs2 {} f))([sm f]
  (let [type- (vector-type2 f)
        
        ;the-meta (first (meta f))
        #_type- #_(if the-meta
                  (if= (key the-meta) :do :thread (single-meta-key-resolve f))
                  c)
        ;;pp (println type- 'f f 'sm sm)
        ]
    (cond 
      (= :do type-)
      (let [;fl (flat2 sm f)
            ;m (if (map? (first fl)) (first fl))
            ;sm2 (if m (l sm m) sm)
            manage-vector (fn [sm f fl] (let [ab (abs2 sm f)] [(rest fl) sm ab]))
            manage-map (fn [sm f fl] (let [type- (map-type2 f)
                                           ;sr (single-meta-key-resolve f)
                                           ;tr (!nil?else sr  #'littlejr.core/l)
                                           ]
                                       (cond (= type- :l) (let [sm2 (l sm f)
                                                                lst (second (ffirst sm2))]
                                                            [(rest fl) sm2 lst])
                                             :else [(rest fl) sm (transform2 sm f)]
                                             #_:else #_(throw (Exception. (str "The handler for :^t[] is not handler for this type of map ^" (meta f) f))))))]
        (loop [fl f sm sm last- nil]
          (if (first fl)
            (let [f (first fl)
                  cond-f (cond (or (symbol? f) (keyword? f))
                               (let [res (resolve2 sm f)
                                     ;fr (f res)
                                     #_cond-fr #_(if res
                                                  (cond (vector? fr) (manage-vector sm fr fl)
                                                        (map? fr) (manage-map sm fr fl)
                                                        :else [(rest fl) sm fr])
                                                  [(rest fl) sm f])
                                     ]#_cond-fr
                                 [(rest fl) sm (f res)])
                               (vector? f) (manage-vector sm f fl)
                               (map? f) (manage-map sm f fl)
                               :else [(rest fl) sm f])
                  ](recur (nth cond-f 0) (nth cond-f 1) (nth cond-f 2)))
            last-)))
      (= :c type-) (c sm f)
      :else (let [res (resolve-keyword type-)]
              (if res (res sm f) (throw (Exception. (str "Don't know what to do with directive " type- ". It must resolve to function " (name type-) ", but couldn't resolve it. Source is ^" (meta f) f ".")))))))))

#_(defn fnl3 ([] (fnl3 nil nil nil))([ss sm f]
   {:let {:l true} :mskip {:fn true}}))

#_(defn walkfn3 [sm kp form]
   (cond
    (list? form) ;(with-meta (outer (apply list (map inner form))) (meta form))
      (with-meta (apply list (map #(walkfn3 sm kp %) form))) (meta form)
    ;(list? form) (outer (apply list (map inner form) ))
    (instance? clojure.lang.IMapEntry form) (map-entry (map #(walkfn3 sm kp %) form))
    (seq? form) (doall (map #(walkfn3 sm kp %) form))
    ;(instance? clojure.lang.IRecord form)
     ; (reduce (fn [r x] (conj r (f x))) form form)
    (map? form) (if ((kp :let) (paradigm-type3 form))
                  (let [ks (keys form)
                        except (kp :except)
                        kp2 (conj kp {:except (apply conj ks except)})]
                    (into (empty form) (map (fn [me] (map-entry (first me) (walkfn3 f (second me) kp2))) form)))
                  (if ((kp :mskip) (paradigm-type3 form)) form
                   
                    (into (empty form) (map #(walkfn3 sm kp %) form))))
    (vector? form) (let [para (paradigm-type3 form)]
                     (if ((kp :fn) para)
                       (let [par])
                       ())
    (coll? form) (do (prn 'map) (outer (into (empty form) (map inner form))))
    :else (outer form))))

#_(defn
   ^{:doc "Like clojure.walk/prewalk but preserves metadata on lists.
Like postwalk, but does pre-order traversal.
NOTE: This code was forked from
https://github.com/clojure/clojure/blob/master/src/clj/clojure/walk.clj
commit 2224dba"}
   prewalkfn3
   [ss sm f]
   (walkfn3 sm (fnl3) f))

(defn paradigm-type3 [f]
  (let [m (meta f)]
    (cond (nil? m) (if (vector? f) :c (if (map? f) :l :s #_(throw (Exception. (str "paradigm-type3: NoMetaException. ^nil " f " meta is nil. Can't handle empty paradigm")))))
          (:jr m) (if (keyword? (:jr m))
                    (:jr m)
                    (throw (Exception. (str "paradigm-type3: NotKeywordException. :jr meta key must map to a keyword. Ex. {:jr :some-vector-handler}, in this case you have to have a function like (defn some-vector-handler [ss sm f]...). Source is ^" (meta f) f))))
          (> (count m) 1) (throw (Exception. (str "paradigm-type3: UndecidableException. More than one meta key. Source is ^" (meta f) f)))
          :else (key (first m)))))

(defn resolve3 ([sm x]
  ;(prn 'RESOLVE-sm sm)
  ;(prn 'RESOLVE-x x)
    (loop [sm sm]
      (if (first sm)
        #_(if (map-entry? x)
           (if (!nil? ((first sm) (second x)))
             (map-entry (first x) ((first sm) (second x))) (recur (rest sm))))
           (if (contains? (first sm) x) {x ((first sm) x)} (recur (rest sm)))
        nil)))
  ([sm x s]
    (if (contains? (into #{} s) x) {x x} (resolve sm x))))

(defn resolve-back3 ([sm x] (resolve3 sm x))
  ([level sm x]
    #_(prn 'resolve-back sm x)
    (loop [l 0 res x last x]
      (if (or (nil? res) (> l level))
        {x last}
        (let [r (resolve3 sm res)
              rs (if (nil? r) nil (r res))
              lst (if (nil? r) last (r res))]
          (recur (inc l) rs lst)))))
  ([level sm x s](if (contains? (into #{} s) x) {x x} (resolve-back3 level sm x))))

(defn defined? [ss sm x])

(def transform-paradigm3 {
  ;^:pre:sym-key:0([](fn [sm x] (prewalk #(if (or (symbol? %)(keyword? %)) (let [res (resolve3 sm %)] (if res (res %) %)) %) x)))
  
      ;(fn [sm x except] (prewalkfn3 (f :let) #(if (and (or (symbol? %) (keyword? %)) (not (contains? except %))) (let [res (resolve3 sm %)] (if res (res %) %)) %) x))
     :pre:sym-key:0:except (fn [sm x except] (prewalk #(if (and (or (symbol? %) (keyword? %)) (not (contains? except %))) (let [res (resolve3 sm %)] (if res (res %) %)) %) x))
     :pre:sym-key:0 (fn [sm x] (prewalk #(if (or (symbol? %)(keyword? %)) (let [res (resolve3 sm %)] (if res (res %) %)) %) x))
     :pos:sym-key:0 (fn [sm x] (postwalk #(if (or (symbol? %)(keyword? %)) (let [res (resolve3 sm %)] (if res (res %) %)) %) x))
     :pre:sym:0 (fn [sm x] (prewalk #(if (symbol? %) (let [res (resolve3 sm %)] (if res (res %) %)) %) x))
     :pos:sym:0 (fn [sm x] (postwalk #(if (symbol? %) (let [res (resolve3 sm %)] (if res (res %) %)) %) x))
     :pre:key:0 (fn [sm x] (prewalk #(if (keyword? %) (let [res (resolve3 sm %)] (if res (res %) %)) %) x))
     :pre:all:0 (fn [sm x] (prewalk #(let [res (resolve3 sm %)] (if res (res %) %)) x))
     :pre:all:1 (fn [sm x] (prewalk #(let [res (resolve-back3 1 sm %)] (if res (res %) %)) x))
     :pos:all:0 (fn [sm x] (postwalk #(let [res (resolve3 sm %)] (if res (res %) %)) x))
     :pos:all:1 (fn [sm x] (postwalk #(let [res (resolve-back3 1 sm %)] (if res (res %) %)) x))})

(declare abs3)
(declare f0-3)
(defn transform3
  ([sm x] (transform3 sm x :pos:sym:0))
  ([sm x par] (transform3 sm x par nil))
  ([sm x par except]
    ;#_(prn 'TRANSFORM3-PAR par)
    ;#_(prn 'TRANSFORM3-X x)
    (let [para (transform-paradigm3 par)]
      (if para
        (if except (para sm x (into #{} except)) (do #_(prn 'TRANSFORM-PARA (para sm x))(para sm x)))
        (throw (Exception. (str "transform3: UnknownTransformationParadigm " par " for " x)))))))

(defn vector3 [ss sm v]
  (into (empty v) (map (partial abs3 ss sm) v))
  )

(defn map3 [ss sm m]
  (let [ks (keys m)
        vs (vals m)
        nks (map (partial abs3 ss sm) ks)
        nvs (map (partial abs3 ss sm) vs)]
    (apply assoc {} (interleave nks nvs)))
  )

(defn midentity3 [v]
  (if (empty? v) {} 
  (apply assoc {} (interleave v v))))

(defn apply3 [ss sm f]
  ;(prn 'apply3-IN "^" (meta f) f)
  (if (map? (first f))
    (let [fi (first f)
          vs (into [] (rest f))
          type- (paradigm-type3 fi)]
          (if (= :x0 type-)
            (let [ks (fi :args)
                  cntks (count ks)
                  cntvs (count vs)
                  n (- cntks cntvs)
                  
                  zm (if (> n 0)
                       (zipmap ks (apply conj vs (vec (replicate n nil))))
                       (zipmap ks vs))]
              #_(prn 'n n 'APPLY3-zm(zipmap ks (apply conj vs (vec (replicate n nil)))))
              #_(prn 'apply3-OUT ^:do[zm (fi :f)])
              (abs3 ss sm ^:do[zm (fi :f)]))
            (throw (Exception. (str "apply3: UnknownParadigmException. Can't handle this kind of map ^" (meta fi) fi ". Source is ^"(meta f) f)))))
    (let [;fapp (resolve2 sm f)
          tr (transform3 sm f)
          fi (first tr)]
      ;(prn 'trd (type tr) tr #_(apply (first f) (rest f)))
      (if (and (or (symbol? fi) (keyword? fi)) (not (map? (second tr)))) (throw (Exception. (str "apply3: NoMapForSymbolAsFunctionException. Source is: ^"(meta f) f)))
        (apply fi (rest tr)))))
  )

(defn flat3 [ss sm f]
  #_(prn 'FLAT3-SM sm)
  #_(prn 'FLAT3-F f)
  (loop [ss ss sm sm f f ef (empty f)]
    (let [fi (first f)]
      (if (!nil? fi)
        (cond (map? fi)(let [type- (paradigm-type3 fi)
                             #_pp #_(prn 'FLAT3-PARADIGM type- fi)]
                         (cond ;(= :fn type-) (recur ss sm (rest f) (conj ef fi)) 
                               (= :l type-) (let [l ((resolve3 ss :l) :l)
                                                  sm2 (l ss sm fi)
                                                  ]
                                          (recur ss sm2 (rest f) ef))
                               ;
                               :else (recur ss sm (rest f) (conj ef fi))))
              (vector? fi) (let [abs (abs3 ss sm fi)]
                             (recur ss sm (rest f) (conj ef abs)))
              :else (let [tr (transform3 sm fi)]
                      (recur ss sm (rest f) (conj ef tr))))
        ef))))

(defn
  ^{:doc "This paradigm is more or less clojure like"}
  call3 [ss sm f]
  (let [;pp (prn 'call3-TOFLAT "^" (meta f) f)
        fl (flat3 ss sm f) fi (first fl)
        ;pp (prn 'call3-FLATTED "^" (meta fl) fl)
        ]
    
    (if (> (count fl) 1)
      (if (!nil? fi)
        (if (or (vector? fi) (seq? fi) (list? fi))
          (if (!nil? (next fl))
            (let [app (apply3 ss sm (concat (rest fl) fi))]
              app)
            (throw (Exception. (str "call3: MalformedStructure. No function to apply to " fi ": " f))))
          (apply3 ss sm fl))
        
        (throw (Exception. (str "call3: NilFunctionException. No function to apply. " (first f) " was nil. Source is " f))))
      (fi))))

(defn flatf0-3 [ss sm f]
  ;(prn 'flatf0-3 f)
  (if (coll? f)
    (loop [ss ss sm sm f- f ef (empty f)]
     (let [fi (first f-)
           #_pp #_(prn 'flatf0-3-f-ef f- ef)]
      (if (!nil? fi)
       (cond (map? fi)(let [type- (paradigm-type3 fi)]
                        (cond (= :l type-) (letfn [(lp [sm ks result]
                                                     (if ks
                                                       (let [k (first ks)
                                                             sm2 (cons {k k} sm)
                                                             fik (fi k)
                                                             fn- (if (coll? fik)
                                                                   (if (= :f0 (paradigm-type3 fik))
                                                                     (f0-3 ss sm2 fik)
                                                                     (flatf0-3 ss sm2 fik))
                                                                   (transform3 sm2 fik))]
                                                         #_(prn 'lp-fn- fn-)
                                                         (lp sm2 (next ks) (conj result {k fn-})))
                                                       {:sm sm :result result}))]
                                             (let [lp- (lp sm (keys fi) (empty fi))]
                                               (recur ss (lp- :sm) (rest f-) (append ef (lp- :result)))))
                              :else (recur ss sm (rest f-) (append ef fi))))
             (vector? fi) (let [type- (paradigm-type3 fi)]
                        (cond (= :f0 type-) (let [id (midentity3 (first fi))
                                                  sm2 (cons id sm)
                                                  fn- (f0-3 ss sm2 fi)
                                                  ef- (append ef fn-)]
                                              (recur ss sm2 (rest f-) ef-))
                              :else (let [tr (flatf0-3 ss sm fi)
                                          ef- (append ef tr)]
                                      (recur ss sm (rest f-) ef-))))
             #_(let [fl (flatf0-3 ss sm fi)]
                (recur ss sm (rest f) (conj ef fl)))
             :else (let [tr (transform3 sm fi)]
                     ;(prn 'FLATY3-else ef tr)
                     (recur ss sm (rest f-) (append ef tr))))
       (do #_(prn 'ef ef) ef))))
    f))

(defn x0-3 [ss sm f] f)

(defn f0-3 [ss sm v]
  #_(prn 'f0-3 v)
  (let [fapp (fn [sm v-]
               (if (vector? (v- 0))
                 (let [argl (v- 0)
                       idn (midentity3 argl)
                       sm2 (if (empty? idn) sm (cons idn sm))
                       tra (into ^:c[] (flatf0-3 ss sm2 (rest v-)))
                       ]
                   ^:x0{:f tra :args (v- 0) :src v}
                   )
                 (let [tra (into ^:c[] (flatf0-3 ss sm v-))]
                   ^:x0{:f tra :args [] :src v})))]
    (fapp sm v)))

#_(defn f1-3 [ss sm v]
   #_(prn 'f0-3 v)
   (let [fapp (fn [sm v-]
                (if (vector? (v- 0))
                  (let [argl (v- 0)
                        idn (midentity3 argl)
                        sm2 (if (empty? idn) sm (cons idn sm))
                        tra (into ^:c[] (flatf1-3 ss sm2 (rest v-)))
                        ]
                    ^:x0{:f tra :args (v- 0) :src v}
                    )
                  (let [tra (into ^:c[] (flatf1-3 ss sm v-))]
                    ^:x0{:f tra :args [] :src v})))]
     (fapp sm v)))

(defn recur3 [ss sm f]
  #_(prn 'RECUR-ms sm)
  #_(prn 'RECUR-f f)
  (into (empty f) (map (partial abs3 ss sm) f)))

(defn loop3 [ss sm f]
  (let [fi (first f)]
    (if (map? fi)
      (let [vec- (into ^:v[] (keys fi))
            fndef (apply conj ^:f0[vec-] (rest f))
            floop (f0-3 ss sm fndef)
            init (into ^:v[] (vals fi))
            ;pp (prn 'LOOP3-fndef fndef)
            ;pp (prn 'LOOP3-floop floop)
            ]
        (loop [i init]
          (let [abs (call3 ss sm [i floop])
                type- (if (meta abs) (paradigm-type3 abs) nil)
                ;pp (prn 'LOOP3-abs abs)
                ]
            (if (= :rc type-)
              (do #_(prn 'LOOP3-recur "^" (meta abs) abs)(recur abs))
              abs))))

      (throw (Exception. (str "loop3: MalformedStructureException. First element must be a map. Source is ^" (meta f) f)))))
  )

(defn
  ^{:doc "This paradigm is more or less clojure like"}
  call3- [ss sm f]
  (loop [sm sm f- f last- nil]
    (let [fi (first f-)]
      (if (!nil? fi)
        (cond (map? fi)(let [type- (paradigm-type3 fi)]
                         (if= type- :l
                              (let [l ((resolve3 ss :l) :l)
                                    sm2 (l ss sm fi)]
                                (recur sm2 (rest f-) (second (ffirst sm2))))
                              (throw (Exception. (str "call3: UnknownParadigmException. call3 can't handle this paradigm ^" (meta fi) fi)))))
              (vector? fi) (if (!nil? (next f-))
                             (let [app (apply3 sm (concat (rest f-) fi))]
                               app)
                             (throw (Exception. (str "call3: MalformedStructure. No function to apply to " fi ": " f))))
                           
              ;(or (symbol? fi) (keyword? fi)) (apply3 sm f-)
              :esle (let [r (resolve3 sm fi)]
                      (if (!nil? r)
                        (if (vector? (r fi))
                          (if (!nil? (next f-))
                             (let [app (apply3 sm (concat (rest f-) (r fi)))]
                               app)
                             (throw (Exception. (str "call3: MalformedStructure. No function to apply to " fi ":" f))))
                          (apply3 sm (cons (r fi) (rest f-))))
                        (apply3 sm f-))))
        last-))))

(defn
  ^{:doc "Named transformlet2."}
  let3 [ss sm m]
  ;(prn m)
  (loop [sm sm m m]
    (let [f (first m)
          ff (first f)
          fv (if (vector? ff) (abs3 ss sm ff) ff)]
      (if f
        (let [sec (second f)]
            (if (or (map? sec) (vector? sec))
              (if (and (map? sec) (= :l (paradigm-type3 sec)))
                (let [abs (abs3 ss sm ^:do[sec])
                      sm2 (cons {fv abs} sm)]
                  (recur sm2 (rest m)))
                (let [abs (abs3 ss sm sec)
                      sm2 (cons {fv abs} sm)]
                  (recur sm2 (rest m))))
              (let [res (resolve3 sm sec)
                    sec-res (if res (sec res) sec)
                    sm2 (cons {fv sec-res} sm)]
                (recur sm2 (rest m)))))
        sm))))

(defn thread3 [ss sm f]
  (let [;fl (flat2 sm f)
            ;m (if (map? (first fl)) (first fl))
            ;sm2 (if m (l sm m) sm)
            manage-vector (fn [ss sm f fl] (let [type- (paradigm-type3 f)]
                                          (cond (= type- :us) (let [us ((resolve3 ss :us) :us)
                                                                    sm2 (us ss sm f)
                                                                    lst (second (ffirst sm2))]
                                                                [(rest fl) ss sm2 lst])
                                                
                                                :else (let [ab (abs3 ss sm f)] [(rest fl) ss sm ab]))))
            manage-map (fn [ss sm f fl] (let [type- (paradigm-type3 f)]
                                          (cond (= type- :l) (let [l ((resolve3 ss :l) :l)
                                                                   sm2 (l ss sm f)
                                                                   lst (second (ffirst sm2))]
                                                               [(rest fl) ss sm2 lst])
                                                (= type- :p) (let [p ((resolve3 ss :p) :p)
                                                                   ss2 (p ss sm f)
                                                                   lst (second (ffirst ss2))]
                                                               [(rest fl) ss2 sm lst])
                                                :else [(rest fl) ss sm (abs3 ss sm f)]
                                                #_:else #_(throw (Exception. (str "The handler for :^t[] is not handler for this type of map ^" (meta f) f)))
                                                )))]
        (loop [fl f ss ss sm sm last- nil]
          (if (first fl)
            (let [f (first fl)
                  cond-f (cond (or (symbol? f) (keyword? f))
                               (let [res (resolve3 sm f)
                                     ;fr (f res)
                                     #_cond-fr #_(if res
                                                  (cond (vector? fr) (manage-vector sm fr fl)
                                                        (map? fr) (manage-map sm fr fl)
                                                        :else [(rest fl) sm fr])
                                                  [(rest fl) sm f])
                                     ]#_cond-fr
                                 [(rest fl) ss sm (f res)])
                               (vector? f) (manage-vector ss sm f fl)
                               (map? f) (manage-map ss sm f fl)
                               :else [(rest fl) ss sm f])
                  ](recur (nth cond-f 0) (nth cond-f 1) (nth cond-f 2) (nth cond-f 3)))
            last-))))

(defn if3 [ss sm v]
    (let [fi (first v)
          type- (if (map? fi) (paradigm-type3 fi) nil)
          l (if (= type- :l) ((resolve3 ss :l) :l) nil)
          sm2 (if l (l ss sm fi) sm)
          v- (if l (subvec v 1) v)
          fapp (fn [v- c sm]
                 (if (or (> 2 c) (< 3 c))
                   (throw (Exception. (str "if3: WrongNumberOfArguments. " c " arguments passed. Source is ^" (meta v) v)))
                   (let [v0 (v- 0) v1 (v- 1)]
                     (if (vector? v0)
                       (if (abs3 ss sm v0)
                         (if (vector? v1) (abs3 ss sm v1) (transform3 sm v1))
                         (if (= 3 c)
                           (if (vector? (v- 2)) (abs3 ss sm (v- 2)) (transform3 sm (v- 2)))
                           nil))
                       (if (transform3 sm v0)
                         (if (vector? v1) (abs3 ss sm v1) (transform3 sm v1))
                         (if (= 3 c)
                           (if (vector? (v- 2)) (abs3 ss sm (v- 2)) (transform3 sm (v- 2)))
                           nil))))))]
      (fapp v- (count v-) sm2)))

(defn sym3 [ss sm s]
  (prn 'sym s)
  (let [r (resolve3 sm s)]
    (if (nil? r) s (r s))))

(defn use3 [ss sm n]
  (let [nsp (map #(let [nsp (ns-publics %)](into {} (reverse nsp))) (reverse n))]
    (concat nsp sm)))


(def jr-defaults3
  (seq [{:do thread3
         :l let3
         :s sym3
         :c call3
         :m map3
         :v vector3
         :f0 f0-3
         :x0 x0-3
         :fl flat3
         :if if3
         :a apply3
         :ff flatf0-3
         :lp loop3
         :rc recur3
         :us use3
         }]))

(def fns {
          'if '^:f0[[x y z] ^:if[x y z]]
          'new (fn [cl & args](clojure.lang.Reflector/invokeConstructor cl (to-array args)))})

(defn abs3 [ss sm f]
  ;(prn 'ABS3 f)
  (let [type- (paradigm-type3 f)
        res (resolve3 ss type-)]
    (if (nil? res)
      (throw (Exception. (str "abs3: UnknownParadigmException ^" (meta f) f)))
      ((res type-) ss sm f))))

(defn jr3
  ([f]
    (let [nsp (ns-publics 'clojure.core) fns- (merge nsp fns)]
    (jr3 (seq [fns-]) f)))
  ([sm f] (let [sm2 (if (seq? sm) sm (if (nil? sm) '() (seq [sm])))] (jr3 jr-defaults3 sm2 f)))
  ([ss sm f]
    (abs3 ss sm f)))

(defn path-from-ns [ns]
     (clojure.string/join
                  [(clojure.string/replace
                     (clojure.string/replace
                       (str ns) #"\." "/") #"-" "_") ".junior"]))

(defn resource-path-of-ns [ns]
  (clojure.string/replace-first
    (str (clojure.java.io/resource (path-from-ns ns)))
    "file:"
    "")
  )

(defn 
  ^{:doc "get File .clj corresponding to the symbol ns"}
  junior-file [ns]
  (let [
        path (path-from-ns ns)
        ]
    (clojure.java.io/as-file (clojure.java.io/resource path))
    )
  )

(defn- read-one
  [r]
  (try
    (binding [*print-meta* true](let [re (read r)  p (prn re)] re))
    (catch java.lang.RuntimeException e
      (if (= "EOF while reading" (.getMessage e))
        ::EOF
        (throw e)))))

(defn read-seq-from-file
  "Reads a sequence of top-level objects in file at path."
  [path]
  (with-open [r (java.io.PushbackReader. (clojure.java.io/reader path))]
    (binding [*read-eval* false]
      (doall (take-while #(not= ::EOF %) (repeatedly #(read-one r)))))))

(defn load-junior [ns]
  (slurp (resource-path-of-ns ns)))

(defn read-junior [ns]
  (read-string (load-junior ns)))

(jr3 '^:do[^:us[junior.core]{:b 1 :a :c}])