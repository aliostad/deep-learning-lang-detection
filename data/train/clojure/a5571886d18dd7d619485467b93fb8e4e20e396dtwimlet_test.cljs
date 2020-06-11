(ns ivr.models.twimlet-test
  (:require [clojure.test :as test :refer-macros [async deftest is run-tests testing use-fixtures]]
            [cljs.spec.test.alpha :as stest]
            [ivr.models.twimlet :as twimlet]))

(use-fixtures :once
  {:before (fn [] (stest/instrument 'ivr.models.twimlet))
   :after (fn [] (stest/unstrument 'ivr.models.twimlet))})


(deftest twimlet-model

  (let [verbs (fn [vs] {:verbs vs})
        deps {:verbs verbs}]

    (testing "loop-play-model"
      (is (= {:ivr.routes/response
              {:verbs
               [{:type :ivr.verbs/loop-play
                 :path "/cloudstore/file/file-id"}]}}
             (twimlet/loop-play-route deps {:params {"file" "file-id"}}))))


    (testing "welcome-model"
      (let [db {:config-info {:config {:business {:welcome_sound "welcome-id"}}}}
            deps {:db db :verbs verbs}]
        (is (= {:ivr.routes/response
                {:verbs
                 [{:type :ivr.verbs/play
                   :path "/cloudstore/file/welcome-id"}]}}
               (twimlet/welcome-route deps)))))))
