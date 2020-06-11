(ns sailing-study-guide.test.dispatch
  (:require-macros [cemerick.cljs.test :refer (is deftest with-test run-tests testing test-var done block-or-done use-fixtures)]
                   [cljs.core.async.macros :refer [go go-loop]])
  (:require [cemerick.cljs.test :as t]
            [cljs.core.async :refer [chan mult tap put! take! <! >! pub sub unsub close!] :as async]
            [sailing-study-guide.dispatch :as dispatcher]))

(defn setup []
  (def *default-tag* :foo)
  (def *default-mesg* 42)
  (def *not-default-mesg* 43)
  (def *default-payload* {:tag *default-tag* :message *default-mesg*}))

(defn teardown [])

(defn each-fixture [f]
  (setup)
  (f)
  (teardown))

(deftest retrieve-message-test
  (is (= *default-mesg* (dispatcher/retrieve-message *default-payload*))))


(deftest ^:async register-test
  (let [c (dispatcher/register *default-tag*)]
    (go
     (>! c *default-payload*))

    (go
     (is (not (nil? (<! c))))
     (done))))

(deftest ^:async unregister-test
  (let [c (dispatcher/register *default-tag*)]
    (dispatcher/unregister *default-tag* c)
    (go
     (is (= nil (<! c)))
     (done))))

(deftest ^:async whenever-test
  (dispatcher/whenever
   *default-tag*
   (fn [mesg]
     (is (= *default-mesg* mesg))
     (is (not= *not-default-mesg* mesg))
     (done)))
  (go (>! dispatcher/dispatch-chan *default-payload*)))

;; (deftest ^:async dispatch-test
;; ;;   (binding [dispatcher/dispatch-chan (chan)]
;;     (go
;;      (let [payload (<! dispatcher/dispatch-pub-chan)]
;;        (println "payload received")
;;        (is (= *default-payload* payload))
;;        (done)))
;;     (dispatcher/dispatch! *default-tag* *default-mesg*))
;; ;; )

;; (deftest ^:async dispatch-test-cb1
;; ;;   (let [c (chan)]
;; ;;     (binding [dispatcher/dispatch-chan c]
;;       (go
;;        (let [payload (<! dispatcher/dispatch-pub-chan)]
;;          (println "payload received")
;;          (is (= *default-payload* payload))
;;          (done)))
;;       (dispatcher/dispatch! *default-tag* *default-mesg*))

(comment


;; (deftest ^:async dispatch-test-cb2
;;   (binding [dispatcher/dispatch-chan (chan)]
;;     (dispatcher/dispatch! *default-tag* *default-mesg*)
;;     (take! dispatcher/dispatch-chan #(do #_(println "Taken!") (done)))))

;; (deftest ^:async dispatch-test-tags
;;   (binding [dispatcher/dispatch-chan (chan)]
;;     (dispatcher/dispatch! [*default-tag* :foo] *default-mesg*)
;;     (take! dispatcher/dispatch-chan #(do (println "Taken one!")))
;;     (take! dispatcher/dispatch-chan #(do (println "Taken two!") (done)))))
)


;; (deftest ^:async core-async-test
;;   (let [inputs (repeatedly 10000 #(go 1))]
;;     (go (is (= 10000 (<! (reduce
;;                            (fn [sum in]
;;                              (go (+ (<! sum) (<! in))))
;;                            inputs))))
;;       (done))))


;; (deftest ^:async pointless-counting
;;   (let [inputs (repeatedly 10000 #(go 1))
;;         complete (chan)]
;;     (go (is (= 10000 (<! (reduce
;;                           (fn [sum in]
;;                             (go (+ (<! sum) (<! in))))
;;                           inputs))))
;;         (>! complete true))
;;     (block-or-done complete)))

;; (deftest ^:async basic-core-async-test
;;   (let [c (chan 1)
;;         val 1234]
;;     (go
;;      (>! c val)
;;      (is (= val (<! c)))
;;      (done))))

;; (deftest ^:async unbuffered-basic-core-async-test
;;   (let [c (chan)
;;         val 1234]
;;     (go
;;      (>! c val))
;;     (go
;;      (is (= val (<! c)))
;;      (done))))

;; (with-test
;;   (defn pennies->dollar-string
;;     [pennies]
;;     {:pre [(integer? pennies)]}
;;     (str "$" (int (/ pennies 100)) "." (mod pennies 100)))
;;   (testing "assertions are nice"
;;     (is (thrown-with-msg? js/Error #"integer?" (pennies->dollar-string 564.2)))))

(use-fixtures :each each-fixture)
