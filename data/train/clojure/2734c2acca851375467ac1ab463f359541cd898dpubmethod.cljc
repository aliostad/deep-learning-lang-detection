(ns glittershark.pubmethod
  (:require [clojure.spec :as s #?@(:cljs [:include-macros true])]
            [clojure.core.specs :as core-specs]
            #?(:clj [glittershark.pubmethod.lib.extend-fn :refer [extend-fn]]))
  #?(:cljs (:require-macros
             [glittershark.pubmethod.lib.extend-fn :refer [extend-fn]])))

(do ;; specs {{{
    (s/def :pub/name simple-symbol?)
    (s/def :pub/dispatch-fn (s/fspec :args (s/cat :input any?) :ret any?))
    (s/def :defpub/args
      (s/cat :name :pub/name
             :docstring (s/? string?)
             :attr-map (s/? (s/map-of keyword? any?))
             :dispatch-fn any?
             :options (s/keys* :opt-un [:pub-options/default])))

    (s/def ::fn-tail (s/alt :arity-1 ::core-specs/args+body
                            :arity-n (s/+ (s/spec ::core-specs/args+body))))
    (s/def :defsub/args
      (s/cat :pub-name symbol?
             :dispatch-val any?
             :aux-key (s/? keyword?)
             :fn-tail ::fn-tail)))
;; }}}

(defprotocol Pubmethod
  (dispatch [this dv args])
  (add-handler [this dv handler]
               [this dv handler aux-key])
  (clear! [this]))

(defn pubmethod? [x] (and (ifn? x) (satisfies? Pubmethod x)))

(defn new-pubmethod
  [p-name dispatch-fn default]
  (let [dispatch-map (atom {})]
    (extend-fn
      ([this & [first-arg & _ :as args]]
        (dispatch this (dispatch-fn first-arg) args))
      Pubmethod
      (dispatch [_ dv args]
        (let [dispatch-map* @dispatch-map
              handlers (get dispatch-map* dv (get dispatch-map* default))]
          (if (seq handlers)
            (let [result (when-let [primary-handler (::primary handlers)]
                           (apply primary-handler args))]
              (doseq [handler (-> handlers (dissoc ::primary) vals)]
                (apply handler args))
              result)
            (throw (ex-info (str "No defined handler " dv
                                 " defined for pubmethod " p-name)
                            {:pubmethod-name p-name
                             :dispatch-value dv
                             :defined-handlers (:keys dispatch-map*)})))))
      (add-handler [this dv handler]
        (swap! dispatch-map assoc-in [dv ::primary] handler)
        this)
      (add-handler [this dv handler aux-key]
        (swap! dispatch-map assoc-in [dv aux-key] handler)
        this)
      (clear! [this] (reset! dispatch-map {}) this))))

(s/fdef new-pubmethod
        :args (s/cat :p-name :pub/name
                     :dispatch-fn :pub/dispatch-fn
                     :default any?)
        :ret pubmethod?)

(defmacro defpub
  "Creates a new pubmethod with the associated dispatch function.
   The docstring and attr-map are optional.

   Pubmethods behave like multimethods dispatching using `dispatch-fn` with
   handlers defined using `defsub`, but additional (named) handlers can be
   defined by giving keys to `defsub`.

   Pubmethods called with an unrecognized dispatch-value will raise an error
   just like `defmulti`. The return value of a call to a pubmethod will be the
   return value of the primary handler for that dispatch value, or nil if no
   primary handler is defined

     => (defpub foo :id)
     => (defsub foo :a [_] 1)
     => (defsub foo :a :aux [_] (println \"hello from aux sub\") 2)
     => (foo {:id 1})
     hello from aux sub
     1"
  {:arglists '([name docstring? attr-map? dispatch-fn & options])}
  [& args]
  (let [{p-name :name
         :keys [docstring attr-map dispatch-fn options]} (s/conform
                                                           :defpub/args args)
        default (get options :default :default)
        m (if docstring
            (assoc attr-map :doc docstring)
            attr-map)
        m (if (meta p-name)
            (conj (meta p-name) m)
            m)
        m (or m {})
        p-name (with-meta p-name m)]
    `(defonce ~p-name (new-pubmethod ~(name p-name) ~dispatch-fn ~default))))
(s/fdef defpub :args :defpub/args)

(defmacro defsub
  "Registers a subscription handler on the given pubmethod.
   Subscription handlers can either be primary, which is the behavior when `key`
   is not specified, or they can be auxiliary, in which case they will be called
   when that dispatch value is called and their return values will be
   discarded. See doc for `defpub` for more"
  {:arglists '([pub-name dispatch-val & fn-tail]
               [pub-name dispatch-val aux-key & fn-tail])}
  [& args]
  (let [{:keys [pub-name dispatch-val aux-key]} (s/conform :defsub/args args)
        fn-tail (drop (if aux-key 3 2) args)]
    `(add-handler ~(with-meta pub-name {:tag `Pubmethod})
                  ~dispatch-val
                  (fn ~@fn-tail)
                  ~@(if aux-key [aux-key] []))))
(s/fdef defsub :args :defsub/args)

; vim:fdm=marker:fmr={{{,}}}:
