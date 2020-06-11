(ns sparkfund.boot-spec-coverage.instrument
  (:require [clojure.spec.alpha :as s]
            [clojure.spec.test.alpha :as stest]))

(defn in-n-out-checking-fn
  [v f fn-spec]
  (let [fn-spec (@#'s/maybe-spec fn-spec)
        conform! (fn [v role spec data args]
                   (let [conformed (s/conform spec data)]
                     (if (= ::s/invalid conformed)
                       (let [caller (->> (@#'stest/stacktrace-relevant-to-instrument
                                          (.getStackTrace (Thread/currentThread)))
                                         first)
                             ed (merge (assoc (s/explain-data* spec [role] [] [] data)
                                              ::s/var v
                                              ::s/args args
                                              ::s/failure :outstrument)
                                       (when caller
                                         {::caller (dissoc caller :class :method)}))]
                         (throw (ex-info
                                 (str "Call to " v " did not conform to spec:\n" (with-out-str (s/explain-out ed)))
                                 ed)))
                       conformed)))]
    (fn
      [& args]
      (if-not @#'stest/*instrument-enabled*
        (.applyTo ^clojure.lang.IFn f args)
        (binding [stest/*instrument-enabled* nil]
          (let [cargs (if (:args fn-spec) (conform! v :args (:args fn-spec) args args) args)]
            (binding [stest/*instrument-enabled* true]
              (let [ret (.applyTo ^clojure.lang.IFn f args)]
                (binding [stest/*instrument-enabled* nil]
                  (let [cret (if (:ret fn-spec) (conform! v :ret (:ret fn-spec) ret args) ret)]
                    (when (:fn fn-spec)
                      (conform! v :fn (:fn fn-spec) {:args cargs :ret cret} args))
                    ret))))))))))

(defn in-n-outstrument-1
  [s opts]
  (when-let [v (resolve s)]
    (when-not (-> v meta :macro)
      (let [spec (s/get-spec v)
            {:keys [raw wrapped]} (get @@#'stest/instrumented-vars v)
            current @v
            to-wrap (if (= wrapped current) raw current)
            ospec (or (@#'stest/instrument-choose-spec spec s opts)
                      (throw (@#'stest/no-fspec v spec)))
            ofn (@#'stest/instrument-choose-fn to-wrap ospec s opts)
            checked (in-n-out-checking-fn v ofn ospec)]
        (alter-var-root v (constantly checked))
        (swap! @#'stest/instrumented-vars assoc v {:raw to-wrap :wrapped checked})
        (stest/->sym v)))))

(defn in-n-outstrument
  "Instruments the function to check :arg, :ret and :fn specs when called.
  Takes the same arguments as clojure.spec.test.alpha/instrument."
  ([] (in-n-outstrument (stest/instrumentable-syms)))
  ([sym-or-syms] (in-n-outstrument sym-or-syms nil))
  ([sym-or-syms opts]
   (locking @#'stest/instrumented-vars
     (into
      []
      (comp (filter (stest/instrumentable-syms opts))
            (distinct)
            (map #(in-n-outstrument-1 % opts))
            (remove nil?))
      (if (symbol? sym-or-syms) (list sym-or-syms) sym-or-syms)))))

(defn in-n-outstrument-namespaces-fixture
  "Fixture to in-n-outstrument all functions in the given namespaces"
  [namespaces]
  (fn [f]
    (let [instrumented (in-n-outstrument (mapcat stest/enumerate-namespace namespaces))]
      (f)
      (stest/unstrument instrumented))))

(defn instrument-namespaces-fixture
  "Fixture to clojure.spec.test.alpha/instrument all functions in the given namespaces"
  [namespaces]
  (fn [f]
    (let [instrumented (stest/instrument (mapcat stest/enumerate-namespace namespaces))]
      (f)
      (stest/unstrument instrumented))))
