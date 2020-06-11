(ns photon.current.integration-test
  (:require [muon-clojure.core :as cl]
            [clojure.tools.logging :as log]
            [clojure.core.async :as async :refer [go-loop <! <!!]]
            [photon.config :as conf]
            [photon.db :as db]
            [photon.muon :as muon]
            [photon.current.common :refer :all])
  (:use midje.sweet))

(defn elem-count [ch]
  (loop [elem (<!! ch) n 0]
    (if (nil? elem)
      n
      (recur (<!! ch) (inc n)))))

(let [uuid (java.util.UUID/randomUUID)
      ms (new-server uuid)
      m (cl/muon-client :local "client-test"
                        "client" "test")
      _ (Thread/sleep 5000)
      res (post-one-event m (str "photon-integration-test-" uuid))
      res (post-one-event m (str "photon-integration-test-" uuid))
      _ (Thread/sleep 5000)
      ch (cl/with-muon m
           (cl/subscribe! (str "stream://photon-integration-test-"
                               uuid "/stream")
                          {:stream-name "__all__"
                           :stream-type "cold"
                           :from 0} ))]
  (facts "Post works correctly"
         (fact (:event-time res) => (roughly (System/currentTimeMillis)))
         (fact (:order-id res) => (roughly (* 1000 (System/currentTimeMillis))))
         (fact res =>
               (contains {:payload {:id "dbd6eecf-8f5c-42aa-8aa8-1b2172d53c71"
                                    :text "substitutable"
                                    :textanalysis {:aggregateSentiment 40
                                                   :keyphrases [{:count 1
                                                                 :phrase "substitutable"}]}}
                          :service-id "request://chatter"
                          :stream-name "chatter"})))
  (fact "Four events on stream" (elem-count ch) => 4)
  (dorun (take 9 (repeatedly
                  (fn []
                    (post-one-event
                     m (str "photon-integration-test-" uuid))))))
  (let [ch (cl/with-muon m
             (cl/subscribe! (str "stream://photon-integration-test-"
                                 uuid "/stream")
                            {:stream-name "__all__"
                             :stream-type "cold"
                             :from 0}))]
    (fact "13 events on stream" (elem-count ch) => 13))
  (dorun (take 100 (repeatedly
                    (fn []
                      (post-one-event
                       m (str "photon-integration-test-" uuid))))))
  (let [ch (cl/with-muon m
             (cl/subscribe! (str "stream://photon-integration-test-"
                                 uuid "/stream")
                            {:stream-name "__all__"
                             :stream-type "cold"
                             :from 0}))]
    (fact "113 events on stream" (elem-count ch) => 113))
  #_(dorun (take 10000 (repeatedly
                        (fn []
                          (post-one-event
                           m (str "photon-integration-test-" uuid))))))
  #_(let [ch (cl/with-muon m
               (cl/subscribe! (str "stream://photon-integration-test-"
                                   uuid "/stream")
                              {:stream-name "__all__"
                               :stream-type "cold"
                               :from 0}))]
      (fact "11011 events on stream" (elem-count ch) => 11011)))

