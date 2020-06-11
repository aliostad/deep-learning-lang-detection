(ns checking-account.test-balance
  (:require [clojure.test :refer :all]
            [cheshire.core :refer :all]
            [clojure-presentation-bws2014.example.checking-account :refer :all]
            [clojure-presentation-bws2014.example.middleware :refer [format-json-params]]
            [compojure.core :refer :all]
            [ring.mock.request :refer :all]))

(def checking-handler-mock
  (-> (ANY "/" [] manage-checking-account)
                    format-json-params))

(deftest test-checking-routes
  (let [post-request (-> (request :post "/" (generate-string {:deposit 10}))
                         (content-type "application/json"))
        response-to-get (checking-handler-mock (request :get "/"))]
    (is (== 200 (response-to-get :status)) "Get status successful.")
    (is (contains? (parse-string (response-to-get :body) true) :balance) "Account balance was fetched by get.")
    ;;Testing depositing
    (is (== 10 ((parse-string ((checking-handler-mock post-request) :body) true) :balance))))) ; Other handler tests...
