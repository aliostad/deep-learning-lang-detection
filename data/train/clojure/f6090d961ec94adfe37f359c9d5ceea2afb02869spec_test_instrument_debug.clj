;   Copyright (c) Rich Hickey. All rights reserved.
;   The use and distribution terms for this software are covered by the
;   Eclipse Public License 1.0 (http://opensource.org/licenses/eclipse-1.0.php)
;   which can be found in the file epl-v10.html at the root of this distribution.
;   By using this software in any fashion, you are agreeing to be bound by
;   the terms of this license.
;   You must not remove this notice, or any other, from this software.

(ns adventofcode1.spec-test-instrument-debug
  (:refer-clojure :exclude [test])
  (:require
   [clojure.pprint :as pp]
   [clojure.spec :as s]
   [clojure.spec.gen :as gen]
   [clojure.string :as str]
   [clojure.spec.test :as stest]
   ))

(in-ns 'clojure.spec.test.check)
(in-ns 'clojure.spec.test)
;;(alias 'stc 'clojure.spec.test.check)

(defn spec-checking-fn
  [v f fn-spec]
  (let [fn-spec (@#'s/maybe-spec fn-spec)
        conform! (fn [v role spec data args]
                   (let [conformed (s/conform spec data)]
                     (if (= ::s/invalid conformed)
                       (let [caller (->> (.getStackTrace (Thread/currentThread))
                                         stacktrace-relevant-to-instrument
                                         first)
                             ed (merge (assoc (s/explain-data* spec [role] [] [] data)
                                              ::s/args args
                                              ::s/failure :instrument)
                                       (when caller
                                         {::caller (dissoc caller :class :method)}))]
                         (throw (ex-info
                                 (str "Call to " v " did not conform to spec:\n" (with-out-str (s/explain-out ed)))
                                 ed)))
                       conformed)))]
    (fn
      [& args]
      (if *instrument-enabled*
        (with-instrument-disabled
          (let [specs fn-spec]
            (let [cargs (when (:args specs) (conform! v :args (:args specs) args args))
                  ret (binding [*instrument-enabled* true]
                        (.applyTo ^clojure.lang.IFn f args))
                  cret (when (:ret specs) (conform! v :ret (:ret specs) ret args))]
              (when (and (:args specs) (:ret specs) (:fn specs))
                (conform! v :fn (:fn specs) {:args cargs :ret cret} args))
              ret)))
        (.applyTo ^clojure.lang.IFn f args)))))

(defn- instrument-1
  [s opts]
  (when-let [v (resolve s)]
    (when-not (-> v meta :macro)
      (let [spec (s/get-spec v)
            {:keys [raw wrapped]} (get @instrumented-vars v)
            current @v
            to-wrap (if (= wrapped current) raw current)
            ospec (or (instrument-choose-spec spec s opts)
                      (throw (no-fspec v spec)))
            ofn (instrument-choose-fn to-wrap ospec s opts)
            checked (spec-checking-fn v ofn ospec)]
        (alter-var-root v (constantly checked))
        (swap! instrumented-vars assoc v {:raw to-wrap :wrapped checked})
        (->sym v)))))

(defn instrument
  "Instruments the vars named by sym-or-syms, a symbol or collection
  of symbols, or all instrumentable vars if sym-or-syms is not
  specified.

  If a var has an :args fn-spec, sets the var's root binding to a
  fn that checks arg conformance (throwing an exception on failure)
  before delegating to the original fn.

  The opts map can be used to override registered specs, and/or to
  replace fn implementations entirely. Opts for symbols not included
  in sym-or-syms are ignored. This facilitates sharing a common
  options map across many different calls to instrument.

  The opts map may have the following keys:

  :spec     a map from var-name symbols to override specs
  :stub     a set of var-name symbols to be replaced by stubs
  :gen      a map from spec names to generator overrides
  :replace  a map from var-name symbols to replacement fns

:spec overrides registered fn-specs with specs your provide. Use
:spec overrides to provide specs for libraries that do not have
  them, or to constrain your own use of a fn to a subset of its
  spec'ed contract.

:stub replaces a fn with a stub that checks :args, then uses the
:ret spec to generate a return value.

:gen overrides are used only for :stub generation.

:replace replaces a fn with a fn that checks args conformance, then
  invokes the fn you provide, enabling arbitrary stubbing and mocking.

:spec can be used in combination with :stub or :replace.

  Returns a collection of syms naming the vars instrumented."
  ([] (instrument (instrumentable-syms)))
  ([sym-or-syms] (instrument sym-or-syms nil))
  ([sym-or-syms opts]
   (locking instrumented-vars
     (into
      []
      (comp (filter (instrumentable-syms opts))
            (distinct)
            (map #(instrument-1 % opts))
            (remove nil?))
      (collectionize sym-or-syms)))))


;; old definition; https://github.com/clojure/clojure/blob/0bc837b9c25ae62185795b2bf2c7952bf6e12d9e/src/clj/clojure/spec.clj
#_(defn- spec-checking-fn
    [v f]
    (let [conform! (fn [v role spec data args]
                     (let [conformed (conform spec data)]
                       (if (= ::invalid conformed)
                         (let [ed (assoc (explain-data* spec [role] [] [] data)
                                         ::args args)]
                           (throw (ex-info
                                   (str "Call to " v " did not conform to spec:\n" (with-out-str (explain-out ed)))
                                   ed)))
                         conformed)))]
      (c/fn
        [& args]
        (if *instrument-enabled*
          (with-instrument-disabled
            (let [specs (fn-specs v)]
              (let [cargs (when (:args specs) (conform! v :args (:args specs) args args))
                    ret (binding [*instrument-enabled* true]
                          (.applyTo ^clojure.lang.IFn f args))
                    cret (when (:ret specs) (conform! v :ret (:ret specs) ret args))]
                (when (c/and (:args specs) (:ret specs) (:fn specs))
                  (conform! v :fn (:fn specs) {:args cargs :ret cret} args))
                ret)))
          (.applyTo ^clojure.lang.IFn f args)))))

;; 1.9-alpha14 version
#_(defn- spec-checking-fn
  [v f fn-spec]
  (let [fn-spec (@#'s/maybe-spec fn-spec)
        conform! (fn [v role spec data args]
                   (let [conformed (s/conform spec data)]
                     (if (= ::s/invalid conformed)
                       (let [caller (->> (.getStackTrace (Thread/currentThread))
                                         stacktrace-relevant-to-instrument
                                         first)
                             ed (merge (assoc (s/explain-data* spec [role] [] [] data)
                                         ::s/args args
                                         ::s/failure :instrument)
                                       (when caller
                                         {::caller (dissoc caller :class :method)}))]
                         (throw (ex-info
                                 (str "Call to " v " did not conform to spec:\n" (with-out-str (s/explain-out ed)))
                                 ed)))
                       conformed)))]
    (fn
     [& args]
     (if *instrument-enabled*
       (with-instrument-disabled
         (when (:args fn-spec) (conform! v :args (:args fn-spec) args args))
         (binding [*instrument-enabled* true]
           (.applyTo ^clojure.lang.IFn f args)))
       (.applyTo ^clojure.lang.IFn f args)))))
