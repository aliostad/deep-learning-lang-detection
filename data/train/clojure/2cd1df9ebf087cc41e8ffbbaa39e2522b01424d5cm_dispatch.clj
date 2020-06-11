(ns com.creeaaakk.cm-dispatch
  (:require [clojure.core.match :refer [clj-form]]

            [com.creeaaakk.dtm-dispatch.protocols.dispatch :as dsp]))

(defn- dispatch-fn
  "Return a dispatch function of one argument. This function receives an event and
   matches it against its known handlers, returning the first handler to match, or
   nil if there are no matches.

     handlers is a sequence of maps of the form:

        - :event   :: core.match pattern row
        - :handler :: function to be returned if the :event is matched"
  [handlers]
  (let [datom (gensym)
        syms (repeatedly (count handlers) gensym)
        clauses (vec (mapcat #(vector [%1] %2) (map :event handlers) syms))
        sym->handler (apply hash-map (interleave (map keyword syms) (map :handler handlers)))]
    (partial (eval `(fn [{:keys ~(vec syms)} ~datom]
                      ~(clj-form [datom] (concat clauses [:else nil]))))
             sym->handler)))

(deftype CoreMatchDispatch
    [table dispatch]

  dsp/IDispatch
  (set-dispatch-table! [_ t]
    (dosync
     (ref-set table t)
     (ref-set dispatch (dispatch-fn (vals t)))))
  (add-dispatch-target! [_ key target]
    (dosync
     (->> target
          (commute table assoc key)
          vals
          dispatch-fn
          (ref-set dispatch))))
  (rem-dispatch-target! [_ key]
    (dosync
     (->> (alter table dissoc key)
          vals
          dispatch-fn
          (ref-set dispatch))))
  (dispatch [_ args]
    (loop [[x & xs] args]
      (when x
        (if-let [handler (@dispatch x)]
          handler
          (recur xs))))))

(defn cm-dispatch
  [table]
  (->CoreMatchDispatch (ref table) (ref (dispatch-fn table))))
