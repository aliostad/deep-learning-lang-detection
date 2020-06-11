(ns rabbitmq-clj.api.users-test
  "Tests related to user endpoints."
  (:require [clojure.test :refer :all]
            [rabbitmq-clj.core :refer [dispatch]]))

(deftest users
  (testing "User endpoints"
    (let [expected-user-perms {:user      "myuser"
                               :vhost     "/"
                               :configure ".*"
                               :write     ".*"
                               :read      ".*"}
          user-vhost-filter (fn [item] (and (= "myuser" (:user item))
                                            (= "/" (:vhost item))))]
      (is (nil? (dispatch :users :add "myuser" "mypassword" "mytag")))
      (is (some #{"myuser"} (map :name (dispatch :users :list))))
      (is (= "myuser" (:name (dispatch :users :list "myuser"))))

      ;; Switch to permissions -- want to prove we caused a change so need to
      ;; do this on a separate user.
      (is (nil? (dispatch :permissions :set "/" "myuser" [".*" ".*" ".*"])))
      (is (= expected-user-perms
             (first
               (filter user-vhost-filter (dispatch :permissions :list)))))
      (is (= expected-user-perms (dispatch :permissions :list "/" "myuser")))
      (is (nil? (dispatch :permissions :clear "/" "myuser")))

      ;; Back to users, delete 'em.
      (is (nil? (dispatch :users :delete "myuser"))))))
