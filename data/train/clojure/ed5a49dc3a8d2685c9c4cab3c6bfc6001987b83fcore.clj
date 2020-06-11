(ns diesel.core
  (:use [roxxi.utils.print]))

(defn of-form? [fn-or-op expr]
  (if (fn? fn-or-op)
    (fn-or-op expr)
    (and (list? expr)
         (not (empty? expr))
         (= (first expr) fn-or-op))))

(defn remove-dispatch-form-cruft
  "Our dispatch forms have `=>` to make them pretty.
Since that isn't valid syntax, this removes that value
and effectively turns `[a => b]` into `[a b]`."
  [dispatch-expr]
  [(first dispatch-expr) (last dispatch-expr)])

(defn ordered-expr-interp [expr dispatch-mappings]
   (loop [op-fns=>ds dispatch-mappings]
    (when op-fns=>ds
      (let [op-fn=>d (first op-fns=>ds)
            op-fn (first op-fn=>d)
            d-val (last op-fn=>d)]
        (if (of-form? op-fn expr)
          d-val
          (recur (next op-fns=>ds)))))))

(defmacro definterp [name formals & dispatch-mappings]
  (let [dispatch-mappings (vec (map remove-dispatch-form-cruft dispatch-mappings))
        expr+formals (vec (cons 'expr formals))]
    `(do
       (defmulti ~name
         (fn ~'intepreter-fn ~expr+formals
           (if (list? ~'expr)
             (or (ordered-expr-interp ~'expr ~dispatch-mappings)
                 :unknown-operator)
             :const-value)))
       (defmethod ~name :const-value ~expr+formals
         (if (symbol? ~'expr)
           @(resolve ~'expr)
           ~'expr))
       (defmethod ~name :unknown-operator ~expr+formals
         (str "Unknown handler for `" ~'expr
              "` when handling `" ~'expr "`")))))

(def special-ops #{'+ '- '/ '*})

(defn special-op? [expr]
  (special-ops (first expr)))

(macroexpand-1
'(definterp my-interp []
   ['add => :add]
   ['sub => :sub]
   [special-op? => :special-op]))

(definterp my-interp []
  ['add => :add]
  ['sub => :sub]
  ['div => :div]
  [special-op? => :special-op])

(defmethod my-interp :add [[_ & args]]
  (apply +  (map my-interp args)))

(defmethod my-interp :sub [[_ & args]]
  (if (= (count args) 1)
    (my-interp (first args))
    (apply - (map my-interp args))))

(defmethod my-interp :div [[_ dividend divisor]]
  (/ dividend divisor))

(defmethod my-interp :special-op [[op & args]]
  (if (= (count args) 1)
    (my-interp (first args))
    (apply @(resolve op) (map my-interp args))))

(def x 10)
(my-interp '(add 6 7))
(my-interp '(add 6 x))

(my-interp '(+ 25 (add 6 (sub 10 x))))

(my-interp '(add 26))

(my-interp '(div 10 20))
