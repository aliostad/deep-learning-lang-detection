(ns note.dispatch.common
  (:require (note.dispatch (path :as path_))
            (ring.util (response :as response_))))

(defn make-predicate
  [& {:keys [method uri f]}]
  (let [uri_ uri]
    (fn [{:keys [request-method uri] :as request}]
      (when (and (= (or method request-method) request-method)
                 (= (or uri_ uri) uri)
                 (if f (f request) true))
        true))))

(defn make
  [pred-fn dispatch-fn]
  {:pred pred-fn
   :dispatch dispatch-fn})

(defn redirect
  [path-id]
  (response_/redirect-after-post (path_/get path-id)))

(defn update-session
  [response f & args]
  (apply update-in response [:session] f args))
