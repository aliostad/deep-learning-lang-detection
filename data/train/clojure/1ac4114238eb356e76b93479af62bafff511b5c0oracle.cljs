(ns oak.oracle
  "An Oracle is a system for determining, perhaps only eventually, answers to
  queries. For instance, a database is naturally a (synchronous) Oracle. So
  is a REST API, though this one is asynchronous.

  Oracles differ in the kinds of queries they respond to and the nature of
  their responses. They are the same in that they manage state in a way
  that's compatible with the explicit nature of Oak.

  In particular, an Oracle operates in stages. During the 'respond' stage,
  the Oracle answers queries to the best of its ability atop a fixed 'model'
  value (it is, therefore, a kind of 'view'). After the 'respond' stage the
  Oracle gets a chance to have a 'research' stage updating the 'model' value
  in knowledge of all of the queries it received during the 'respond' stage.

  Notably, an Oracle must usually respond even before doing any research such
  that asynchronous Oracles will probably return empty responses at first.
  Importantly, the 'respond' stage must be completely pure---no side effects
  allowed! All of the side effects occur during the 'research' phase offering a
  mechanism for asynchronous data loading."
  (:require
    [schema.core :as s]
    [oak.component :as oak]))

; TODO Oracles, being async, would benefit a lot from selective receives in
; the step function (a la Erlang). The heart of this is that a selective receive
; can be used to simplify state management when multiple events chain together.
; The API here is a little tricky since on one hand we'd need to pass in the
; "receive" function and on the other hand we'd want to use Clojure's pattern
; matching macro to make it work, but the benefits could be large for complex
; Oracles. TBI!

; -----------------------------------------------------------------------------
; Type

(defprotocol IOracle
  (model [this])
  (action [this])
  (query [this])
  (stepf [this])
  (startf [this])
  (stopf [this])
  (respondf [this])
  (refreshf [this]))

(defn step
  ([oracle action] (fn [model] (step oracle action model)))
  ([oracle action model] ((stepf oracle) action model)))

(defn start
  [this submit] ((startf this) submit))

(defn stop
  [this rts] ((stopf this) rts))

(defn respond
  ([oracle model] (fn respond-to-query [query] (respond oracle model query)))
  ([oracle model query] ((respondf oracle) model query)))

(defn refresh
  [oracle model queries submit]
  ((refreshf oracle) model queries submit))

(defn substantiate
  "Given an Oak component, try to construct its query results."
  [oracle oracle-model component component-model]
  (let [base-responder (respond oracle oracle-model)
        query-capture (atom #{})
        q (fn execute-query [query]
            (swap! query-capture conj query)
            (base-responder query))]
    {:result (oak/query component component-model q)
     :queries @query-capture}))

; -----------------------------------------------------------------------------
; Type

(deftype Oracle
  [model action query stepf startf stopf respondf refreshf]

  IOracle
  (model [_] model)
  (action [_] action)
  (query [_] query)
  (stepf [_] stepf)
  (startf [_] startf)
  (stopf [_] stopf)
  (respondf [_] respondf)
  (refreshf [_] refreshf))

; -----------------------------------------------------------------------------
; Intro

(def +default-options+
  {:model s/Any
   :action s/Any
   :query s/Any
   :step  (fn default-step [_action model] model)
   :start (fn default-start [_submit])
   :stop (fn default-stop [_rts])
   :respond (fn [_model _query] nil)
   :refresh (fn [_model _queries _submit])
   :disable-validation false})

(defn make*
  [options]
  (let [options (merge +default-options+ options)
        {:keys [model action query step start stop
                respond refresh
                disable-validation]} options
        model-validator (s/validator model)
        action-validator (s/validator action)
        query-validator (s/validator query)
        validated-respond (fn validated-respond [model q]
                            (respond model (query-validator q)))
        validated-step (fn validated-step [action model]
                         (model-validator
                           (step (action-validator action) model)))]
    (Oracle.
      model action query
      (if disable-validation step validated-step)
      start stop
      (if disable-validation respond validated-respond)
      refresh)))

(defn make [& {:as options}] (make* options))

