(ns components.metrics.instrument
  (:require
    [components.metrics.protocol :as metrics]))

(defmulti install (fn [_ _ _ definition] (:type definition)))

(defmethod install :metrics/counter
  [system-monitor source-namespace id definition]
  (metrics/add-counter! system-monitor id (:title definition)))

(defmethod install :metrics/histogram
  [system-monitor source-namespace id definition]
  (metrics/add-histogram! system-monitor id (:title definition)))

(defmethod install :metrics/gauge
  [system-monitor source-namespace id definition]
  (metrics/add-gauge! system-monitor id (:title definition) (:function definition)))

(defmethod install :metrics/meter
  [system-monitor source-namespace id definition]
  (metrics/add-meter! system-monitor id (:title definition)))

(defmethod install :metrics/timer
  [system-monitor source-namespace id definition]
  (metrics/add-timer! system-monitor id (:title definition)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defn infer-title [source-namespace id]
  (let [fqtitle (clojure.string/split
                  (format "%s.%s" source-namespace (name id))
                  #"\.")]
    (conj
      (subvec fqtitle 0 2)
      (apply str (interpose "." (subvec fqtitle 2))))))

(defn namespaces [ns-head]
  (let [re (re-pattern (format "%s\\..*" ns-head))]
    (->> (all-ns)
         (map str)
         (filter #(re-matches re %)))))

(defn has-function
  [ns-name fn-name]
  (get (ns-publics (symbol ns-name)) (symbol fn-name)))

(defn instrument-ns
  [ns-name fn-name state]
  (do
    (doall (map (fn [[id definition]]
                  (install state ns-name id
                           (update-in definition
                                      [:title]
                                      #(if % % (infer-title ns-name id)))))
                (apply (get (ns-publics (symbol ns-name)) (symbol fn-name)) '())))))

(defn instrument-all
  [state root-ns]
  (let [fn-name "instruments"]
    (->>
      (namespaces root-ns)
      (filter #(has-function % fn-name))
      (map #(instrument-ns % fn-name state))
      (doall))))

(defmacro install-instruments!
  [definition]
  `(defn ~'instruments [] ~definition))

