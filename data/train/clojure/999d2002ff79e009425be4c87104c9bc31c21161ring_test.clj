(ns outpace.metrics-delivery.ring-test
  (:require
    [clojure.test :refer :all]
    [outpace.metrics-delivery.ring :refer :all]
    [metrics.reporters.console :as console]
    [ring.middleware.defaults :refer [wrap-defaults api-defaults]]
    [ring.mock.request :as mock]
    [compojure.core :refer [defroutes GET]]))

(defroutes test-routes
  (GET "/status" req "Running")
  (GET "/user/:id" [id] {:status 200
                         :body (str id)}))

(def handler
  (-> test-routes
    (wrap-defaults api-defaults)
    (instrument-by-uri)
    (instrument-by-routes ["/status" "/user/:id"])))

(deftest tagged-literalt
  (is (match ["/status"] {:uri "/status"})))

(deftest ring-still-serves-requests
  (let [r (console/reporter {})]
    (console/start r 1)
    (try
      (is (= "Running"
             (:body (handler (mock/request :get "/status")))))
      (is (= "123"
             (:body (handler (mock/request :get "/user/123")))))
      (is (= "222"
             (:body (handler (mock/request :get "/user/222")))))
      (Thread/sleep 1001)
      (finally
        (console/stop r)))))
