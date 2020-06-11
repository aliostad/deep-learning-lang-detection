(ns handlers.core
  (:require [dispatch-map.core :refer (dispatch-map)]))

(defprotocol IHandler
  (-enter [this])
  (-return [this x])
  (-handle [this e])
  (-exit [this]))

(deftype Handler [dispatch]
  IHandler
  (-enter [_]
    ((:enter dispatch)))
  (-handle [_ e]
    ((or (dispatch (class e)) (:default dispatch)) e))
  (-return [_ x]
    ((:return dispatch) x))
  (-exit [_]
    ((:exit dispatch))))

(def empty-dispatch
  (dispatch-map identity
    :enter (constantly nil)
    :return identity
    :default #(throw %)
    :exit (constantly nil)))

(def empty-handler (Handler. empty-dispatch))

(defn handler
  ([] empty-handler)
  ([& cases]
   (Handler. (apply assoc empty-dispatch cases))))

(defn with-handler* [handler f & args]
  (try
    (-enter handler)
    (-return handler (apply f args))
    (catch Throwable e
      (-handle handler e))
    (finally
      (-exit handler))))

(defmacro with-handler [handler & body]
  `(with-handler* ~handler (fn [] ~@body)))

(defmacro handle [clauses & body]
  (let [cases (mapcat (fn [[k v]]
                        [k (if (#{:enter :exit} k)
                             `(fn [] ~v)
                             (cons `fn v))])
                      (partition 2 clauses))]
    `(with-handler (handler ~@cases) ~@body)))


(comment

  (with-handler empty-handler 1)
  (with-handler empty-handler (throw (Exception. "ERR")))

  (def logger
    (handler :enter #(println "ENTER")
             :default (fn [e]
                        (println "ERROR: " (pr-str e))
                        (throw e))
             :return (fn [x]
                       (println "RETURN: " (pr-str x))
                       x)
             :exit #(println "EXIT")))

  (with-handler logger 1)
  (with-handler logger (throw (Exception. "OMG")))

  (def incrementer
    (handler :return inc))

  (with-handler incrementer 1)
  (with-handler incrementer (throw (Exception. "OMG")))

  (def specific
    (handler Throwable (fn [_] "base")
             Exception (fn [_] "derived")))

  (with-handler specific (throw (Throwable.)))
  (with-handler specific (throw (Exception.)))
  (with-handler specific (throw (RuntimeException.)))

  (-> '(handle [:enter "enter"
                RuntimeException ([e] "RTE")
                :default ([e] "default")
                :return ([x] x)
                :exit "exit"]
         ;(throw (Exception. "e"))
         (throw (RuntimeException. "e"))
         "body")
      ;eval
      macroexpand
      fipp.edn/pprint
      )

)
