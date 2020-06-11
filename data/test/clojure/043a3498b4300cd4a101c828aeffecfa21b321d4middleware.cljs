(ns rex.middleware)

(defonce *middlewares-init-value* [])
(defonce middlewares (atom *middlewares-init-value*))

(defn reset-middlewares! []
  (reset! middlewares *middlewares-init-value*))

(defn get-middlewares []
  @middlewares)

(defn defmiddleware
  [middleware]
  (swap! middlewares conj {:name (get (meta middleware) :name nil)
                           :fn middleware}))

(defn id-middleware
  "trivial middleware, just delegate to next dispatch function"
  [action store next-dispatch-fn]
  (next-dispatch-fn action store next-dispatch-fn))
