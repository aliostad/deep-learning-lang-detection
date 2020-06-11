(ns zombunity.login-test
  (:use clojure.test)
  (:require [zombunity.dispatch :as disp]
            [zombunity.data :as data]
            [zombunity.data.login-data :as login-data]))

(def first-run {"login_state" {:conn_id 1 :num_logins 1 :num_passwords 0}
                "msg-to-client" {:conn-id 1 :message "enter login:"}
                "user" {:login "alice", :id 1, :password "1234"}})

(def login-entered {"login_state" {:conn_id 1 :num_logins 1 :num_passwords 1 :login "alice"}
                    "msg-to-client" {:conn-id 1 :message "enter password:"}
                    "user" {:login "alice", :id 1, :password "1234"}})

(def login-succeeded {"msg-to-client" {:conn-id 1 :message "login successful"}
                      "user" {:login "alice", :id 1, :password "1234"}
                      "msg-to-server" {:conn-id 1, :user-id 1, :type :user-logged-in}})

(def first-wrong-password {"login_state" {:conn_id 1 :num_logins 2 :num_passwords 1 :login "alice"}
                           "msg-to-client" {:conn-id 1 :message "enter login:"}
                           "user" {:login "alice", :id 1, :password "1234"}})

(def login-failed {"msg-to-client" {:conn-id 1 :message "enter password:"}
                   "user" {:login "alice", :id 1, :password "1234"}
                   "msg-to-server" {:type "login-max-attempts" :conn-id 1}})

(deftest test-login-success-first-try
  (disp/register-daemon  (first (disp/filter-classpath-namespaces #"\.login$")))

  (data/set-target :zombunity.data.login-data/login)
  (reset! login-data/data {"user" {:id 1 :login "alice" :password "1234"}})

  (disp/dispatch {:type "login" :conn-id 1})

  (is (= first-run @login-data/data) "Initial login prompt")

  (disp/dispatch {:type "alice" :conn-id 1})

  (is (= login-entered @login-data/data) "Login entered")

  (disp/dispatch {:type "1234" :conn-id 1})

  (is (= login-succeeded @login-data/data) "Password entered")

  (is (= nil (get "login_state" @login-data/data))))

(deftest test-login-fail-once-then-succeed
  (disp/register-daemon  (first (disp/filter-classpath-namespaces #"\.login$")))

  (data/set-target :zombunity.data.login-data/login)
  (reset! login-data/data {"user" {:id 1 :login "alice" :password "1234"}})

  (disp/dispatch {:type "login" :conn-id 1})
  (disp/dispatch {:type "alice" :conn-id 1})
  (disp/dispatch {:type "123" :conn-id 1})

  (is (= first-wrong-password @login-data/data) "First failure")

  (disp/dispatch {:type "alice" :conn-id 1})
  (disp/dispatch {:type "1234" :conn-id 1})

  (is (= login-succeeded @login-data/data) "Success after first failure"))

(deftest test-login-fail
  (disp/register-daemon  (first (disp/filter-classpath-namespaces #"\.login$")))

  (data/set-target :zombunity.data.login-data/login)
  (reset! login-data/data {"user" {:id 1 :login "alice" :password "1234"}})

  (disp/dispatch {:type :login :conn-id 1})
  (disp/dispatch {:type "alice" :conn-id 1})
  (disp/dispatch {:type "wrong password" :conn-id 1})
  (disp/dispatch {:type "bob" :conn-id 1})
  (disp/dispatch {:type "1234" :conn-id 1})
  (disp/dispatch {:type "" :conn-id 1})
  (disp/dispatch {:type "wrong password" :conn-id 1})

  (is (= login-failed @login-data/data) "Password entered"))
