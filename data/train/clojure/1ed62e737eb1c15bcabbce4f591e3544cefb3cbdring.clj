(ns janus.ring
  (:require [janus.route :as route]))

(defprotocol Dispatchable
  (dispatch [this request args]))

(extend-protocol Dispatchable
  nil
  (dispatch [this request dispatch-table] (get dispatch-table this))
  clojure.lang.Fn
  (dispatch [this request _]
    (this request))
  clojure.lang.Var
  (dispatch [this request _]
    ((deref this) request))
  clojure.lang.Keyword
  (dispatch [this request dispatch-table]
    (let [f (get dispatch-table this)]
      (assert f (format "No dispatch function found for keyword %s" this))
      (f request)))
  clojure.lang.Symbol
  (dispatch [this request dispatch-table]
    (let [f (get dispatch-table this)]
      (assert f (format "No dispatch function found for symbol %s" this))
      (f request)))
  janus.route.Router
  (dispatch [this request dispatch-table]
    (let [[_ [_ dispatchable _]] (route/node this)]
      (dispatch dispatchable request dispatch-table))))

(defn make-dispatcher
  ([] (make-dispatcher {}))
  ([dispatch-table]
   (let [dispatch-table (merge {nil {:status 404 :body "Not Found"
                                     :headers {"Content-Type" "text/plain"}}}
                               dispatch-table)]
     (fn dispatcher
       [{:keys [route-params params] router ::router :as request}]
       (let [request (if (and params route-params)
                       (update request :params merge (into {} (filter (fn [[k v]] (keyword? k)))
                                                           route-params))
                       request)]
         (dispatch router request dispatch-table))))))

(defn wrap-identify
  "Create Ring middleware to identify the route of a request based on `:path-info` or `:uri`"
  [handler router]
  {:pre [(instance? janus.route.Router router)]}
  (fn identifier
    [{:keys [uri path-info] :as req}]
    (let [r (route/identify router (or path-info uri))
          route-params (when r (into {} (route/parameters r)))
          req (if route-params (assoc req :route-params route-params) req)]
      (handler (assoc req ::router r)))))

(def ^:deprecated make-identifier wrap-identify)
