(ns cljs.node.io
  (:refer-clojure :exclude [with-open]))

(defmacro with-open [bindings & body]
  (assert (= 2 (count bindings)) "Incorrect with-open bindings")
  (assert `(satisfies? cljs.node.types.stream.Openable ~(first bindings))
          "Bindings must be Openable")
  `(let [~@bindings]
     (cljs.node.types.stream/open
      ~(first bindings)
      (fn [& _#]
        (try
          (do ~@body)
          (finally
            (when (satisfies? cljs.node.types.stream.Closeable ~(first bindings))
              (cljs.node.types.stream/close ~(first bindings)))))))))
