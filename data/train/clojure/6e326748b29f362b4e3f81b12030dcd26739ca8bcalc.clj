(ns web.calc
  (:require [compojure.core :refer [routes GET]]
            [hiccup.core :refer [html]]
            [hiccup.page :refer [html5]]
            [ring.adapter.jetty :refer [run-jetty]]
            [ring.util.response :as ring]
            [ring.middleware.params :refer [wrap-params]]
            [ring.middleware.keyword-params :refer [wrap-keyword-params]]))

;; produces a hiccup html snippet, not a whole page or response
(defn hello [name]
  (list
   [:h1 "Welcome"]
   [:p "Hello " name]))

;; custom middleware to "double up" the body of a handler's response
(defn run-twice [handler]
  (fn [request]
    (when-let [response (handler request)]
      (update-in response [:body]
                 (fn [body]
                   (cond (sequential? body) (list body body)
                         (string? body) (str body body)
                         :else body))))))

;; an example of working with a ring request-map by hand
(defn raw-handler [request]
  (when (= {:scheme :http, :uri "/test", :request-method :get}
           (select-keys request [:scheme :uri :request-method]))
    (let [{:keys [arg]} (:params request)]
      (ring/response (hello arg)))))

;; wraps the body of a handler's response with html doctype, etc
(defn wrap-html [handler]
  (fn [request]
    (when-let [response (handler request)]
      (update-in response [:body] #(html5 %)))))

;; tries each route, and use the first non-nil result
(def handler (routes (run-twice raw-handler) ;; middleware around only one of the handlers
                     (GET "/hello" [name]
                       ;; compojure simplifies over raw-handler
                       (hello name))))


(def app (-> (routes (wrap-html handler) ;; middleware around all the handlers
                     (constantly {:status 404 :body "Not found"})) ;; a default handler
             (wrap-keyword-params) ;; middlewares for parsing query params
             (wrap-params)))

;; functions to manage the jetty server
(defonce jetty (atom nil))

(defn start []
  (reset! jetty (run-jetty #'app {:join? false :port 8088})))

(defn stop []
  (.stop @jetty)
  (reset! jetty nil))