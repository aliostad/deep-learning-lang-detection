(ns dispatch.multimethods
  (:refer-clojure :exclude [remove-all-methods remove-method prefer-method
                            methods get-method prefers defmulti defmethod])
  (:use [dispatch.is-a-protocol :only [is-a? global-is-a-hierarchy]]))

;;; mostly stolen from clojurescript

;;NB: hierarchy must be IRef
;; in this case, use Var; in cljs, they use Atom
(defn- reset-cache
  [method-cache method-table cached-hierarchy hierarchy]
  (swap! method-cache (fn [_] (deref method-table)))
  (swap! cached-hierarchy (fn [_] (deref hierarchy))))

(defn- prefers*
  [x y prefer-table]
  (let [xprefs (@prefer-table x)]
    (or
     (when (and xprefs (xprefs y))
       true)
     (loop [ps (parents y)]
       (when (pos? (count ps))
         (when (prefers* x (first ps) prefer-table)
           true)
         (recur (rest ps))))
     (loop [ps (parents x)]
       (when (pos? (count ps))
         (when (prefers* (first ps) y prefer-table)
           true)
         (recur (rest ps))))
     false)))

(defn- dominates
  [x y prefer-table]
  (or (prefers* x y prefer-table) (is-a? x y)))

(defn- find-and-cache-best-method
  [name dispatch-val hierarchy method-table prefer-table method-cache cached-hierarchy]
  (let [best-entry (reduce (fn [be [k _ :as e]]
                             (if (is-a? dispatch-val k)
                               (let [be2 (if (or (nil? be) (dominates k (first be) prefer-table))
                                           e
                                           be)]
                                 (when-not (dominates (first be2) k prefer-table)
                                   (throw (Error.
                                           (str "Multiple methods in multimethod '" name
                                                "' match dispatch value: " dispatch-val " -> " k
                                                " and " (first be2) ", and neither is preferred"))))
                                 be2)
                               be))
                           nil @method-table)]
    (when best-entry
      (if (= @cached-hierarchy @hierarchy)
        (do
          (swap! method-cache assoc dispatch-val (second best-entry))
          (second best-entry))
        (do
          (reset-cache method-cache method-table cached-hierarchy hierarchy)
          (find-and-cache-best-method name dispatch-val hierarchy method-table prefer-table
                                      method-cache cached-hierarchy))))))

(defprotocol IMultiFn
  (-reset [mf])
  (-add-method [mf dispatch-val method])
  (-remove-method [mf dispatch-val])
  (-prefer-method [mf dispatch-val dispatch-val-y])
  (-get-method [mf dispatch-val])
  (-methods [mf])
  (-prefers [mf])
  (-dispatch [mf args]))

(defn- do-dispatch
  [mf dispatch-fn args]
  (let [dispatch-val (apply dispatch-fn args)
        target-fn (-get-method mf dispatch-val)]
    (when-not target-fn
      (throw (Error. (str "No method in multimethod '" name "' for dispatch value: " dispatch-val))))
    (apply target-fn args)))

(deftype MultiFn [name dispatch-fn default-dispatch-val hierarchy
                  method-table prefer-table method-cache cached-hierarchy]
  IMultiFn
  (-reset [mf]
    (swap! method-table (fn [mf] {}))
    (swap! method-cache (fn [mf] {}))
    (swap! prefer-table (fn [mf] {}))
    (swap! cached-hierarchy (fn [mf] nil))
    mf)

  (-add-method [mf dispatch-val method]
    (swap! method-table assoc dispatch-val method)
    (reset-cache method-cache method-table cached-hierarchy hierarchy)
    mf)

  (-remove-method [mf dispatch-val]
    (swap! method-table dissoc dispatch-val)
    (reset-cache method-cache method-table cached-hierarchy hierarchy)
    mf)

  (-get-method [mf dispatch-val]
    (when-not (= @cached-hierarchy @hierarchy)
      (reset-cache method-cache method-table cached-hierarchy hierarchy))
    (if-let [target-fn (@method-cache dispatch-val)]
      target-fn
      (if-let [target-fn (find-and-cache-best-method name dispatch-val hierarchy method-table
                                                     prefer-table method-cache cached-hierarchy)]
        target-fn
        (@method-table default-dispatch-val))))

  (-prefer-method [mf dispatch-val-x dispatch-val-y]
    (when (prefers* dispatch-val-x dispatch-val-y prefer-table)
      (throw (Error. (str "Preference conflict in multimethod '" name "': " dispatch-val-y
                   " is already preferred to " dispatch-val-x))))
    (swap! prefer-table
           (fn [old]
             (assoc old dispatch-val-x
                    (conj (get old dispatch-val-x #{})
                          dispatch-val-y))))
    (reset-cache method-cache method-table cached-hierarchy hierarchy))

  (-methods [mf] @method-table)
  (-prefers [mf] @prefer-table)

  (-dispatch [mf args] (do-dispatch mf dispatch-fn args))

  ;; IHash
  ;; (-hash [this] (hash this))

  clojure.lang.IFn
  ;;TODO: do we need all these? can it just be
  ;;(invoke [this & args] (-dispatch this args))
  (invoke [this] (-dispatch this ()))
  (invoke [this a1] (-dispatch this (list a1)))
  (invoke [this a1 a2] (-dispatch this (list a1 a2)))
  (invoke [this a1 a2 a3] (-dispatch this (list a1 a2 a3)))
  (invoke [this a1 a2 a3 a4] (-dispatch this (list a1 a2 a3 a4)))
  (invoke [this a1 a2 a3 a4 a5] (-dispatch this (list a1 a2 a3 a4 a5)))
  (invoke [this a1 a2 a3 a4 a5 a6] (-dispatch this (list a1 a2 a3 a4 a5 a6)))
  (invoke [this a1 a2 a3 a4 a5 a6 a7] 
    (-dispatch this (list a1 a2 a3 a4 a5 a6 a7)))
  (invoke [this a1 a2 a3 a4 a5 a6 a7 a8] 
    (-dispatch this (list a1 a2 a3 a4 a5 a6 a7 a8)))
  (invoke [this a1 a2 a3 a4 a5 a6 a7 a8 a9] 
    (-dispatch this (list a1 a2 a3 a4 a5 a6 a7 a8 a9)))
  (invoke [this a1 a2 a3 a4 a5 a6 a7 a8 a9 a10] 
    (-dispatch this (list a1 a2 a3 a4 a5 a6 a7 a8 a9 a10)))
  (invoke [this a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11] 
    (-dispatch this (list a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11)))
  (invoke [this a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12] 
    (-dispatch this (list a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12)))
  (invoke [this a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13] 
    (-dispatch this (list a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13)))
  (invoke [this a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14] 
    (-dispatch this (list a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14)))
  (invoke [this a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15] 
    (-dispatch this (list a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 
                          a11 a12 a13 a14 a15)))
  (invoke [this a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 a16] 
    (-dispatch this (list a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 
                          a11 a12 a13 a14 a15 a16)))
  (invoke [this a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 a16 a17] 
    (-dispatch this (list a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 
                          a11 a12 a13 a14 a15 a16 a17)))
  (invoke [this a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 
                a11 a12 a13 a14 a15 a16 a17 a18] 
    (-dispatch this (list a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 
                          a11 a12 a13 a14 a15 a16 a17 a18)))
  (invoke [this a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 
                a11 a12 a13 a14 a15 a16 a17 a18 a19] 
    (-dispatch this (list a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 
                          a11 a12 a13 a14 a15 a16 a17 a18 a19)))
  (invoke [this a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 
                a11 a12 a13 a14 a15 a16 a17 a18 a19 a20] 
    (-dispatch this (list a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 
                          a11 a12 a13 a14 a15 a16 a17 a18 a19 a20)))
  (invoke [this a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 
                a11 a12 a13 a14 a15 a16 a17 a18 a19 a20 restargs] 
    (-dispatch this (list a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 
                          a11 a12 a13 a14 a15 a16 a17 a18 a19 a20 restargs)))
  (applyTo [this args] (-dispatch this args)))

;;; metafns on multimethods

(defn remove-all-methods
  "Removes all of the methods of multimethod."
 [multifn]
 (-reset multifn))

(defn remove-method
  "Removes the method of multimethod associated with dispatch-value."
 [multifn dispatch-val]
 (-remove-method multifn dispatch-val))
(defn prefer-method
  "Causes the multimethod to prefer matches of dispatch-val-x over dispatch-val-y
   when there is a conflict"
  [multifn dispatch-val-x dispatch-val-y]
  (-prefer-method multifn dispatch-val-x dispatch-val-y))

(defn methods
  "Given a multimethod, returns a map of dispatch values -> dispatch fns"
  [multifn] (-methods multifn))

(defn get-method
  "Given a multimethod and a dispatch value, returns the dispatch fn
  that would apply to that value, or nil if none apply and no default"
  [multifn dispatch-val] (-get-method multifn dispatch-val))

(defn prefers
  "Given a multimethod, returns a map of preferred value -> set of other values"
  [multifn] (-prefers multifn))

;;; creating multimethods

(defn ^:private check-valid-options
  "Throws an exception if the given option map contains keys not listed
  as valid, else returns nil."
  [options & valid-keys]
  (when (seq (apply disj (apply hash-set (keys options)) valid-keys))
    (throw
     (apply str "Only these options are valid: "
            (first valid-keys)
            (map #(str ", " %) (rest valid-keys))))))

(defmacro defmulti
  "Creates a new multimethod with the associated dispatch function.
  The docstring and attribute-map are optional.

  Options are key-value pairs and may be one of:
    :default    the default dispatch value, defaults to :default
    :hierarchy  the isa? hierarchy to use for dispatching
                defaults to the global hierarchy"
  [mm-name & options]
  (let [docstring   (if (string? (first options))
                      (first options)
                      nil)
        options     (if (string? (first options))
                      (next options)
                      options)
        m           (if (map? (first options))
                      (first options)
                      {})
        options     (if (map? (first options))
                      (next options)
                      options)
        dispatch-fn (first options)
        options     (next options)
        m           (if docstring
                      (assoc m :doc docstring)
                      m)
        m           (if (meta mm-name)
                      (conj (meta mm-name) m)
                      m)]
    (when (= (count options) 1)
      (throw "The syntax for defmulti has changed. Example: (defmulti name dispatch-fn :default dispatch-value)"))
    (let [options   (apply hash-map options)
          default   (get options :default :default)]
      (check-valid-options options :default :hierarchy)
      `(def ~(with-meta mm-name m)
         (let [method-table# (atom {})
               prefer-table# (atom {})
               method-cache# (atom {})
               cached-hierarchy# (atom {})
               hierarchy# (get ~options :hierarchy #'global-is-a-hierarchy)]
           (MultiFn. ~(name mm-name) ~dispatch-fn ~default hierarchy#
                               method-table# prefer-table# method-cache# cached-hierarchy#))))))

(defmacro defmethod
  "Creates and installs a new method of multimethod associated with dispatch-value. "
  [multifn dispatch-val & fn-tail]
  `(-add-method ~(with-meta multifn {:tag 'multimethods/MultiFn}) ~dispatch-val (fn ~@fn-tail)))

;;TODO: need to throw useful exceptions when dispatch fails
