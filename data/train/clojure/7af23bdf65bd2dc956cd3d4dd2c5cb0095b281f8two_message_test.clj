(ns bottle.messaging.two-message-test
  (:require [bottle.macros :refer [with-system]]
            [bottle.messaging.consumer :as consumer]
            [bottle.messaging.producer :as producer]

            [bottle.messaging.consumer.activemq]
            [bottle.messaging.consumer.rabbitmq]
            [bottle.messaging.consumer.stream]

            [bottle.messaging.producer.activemq]
            [bottle.messaging.producer.rabbitmq]
            [bottle.messaging.producer.stream]

            [clojure.test :refer [deftest testing is]]
            [com.stuartsierra.component :as component]
            [manifold.stream :as stream]
            [bottle.messaging.stream-manager :as stream-manager])
  (:import [bottle.messaging.handler MessageHandler]))

(def queue-name "two-message-test")

(defn system [config]
  (let [messages (stream/stream)]
    {:messages messages
     :consumer (component/using
                   (consumer/consumer config)
                 [:handler])
     :producer (producer/producer config)
     :handler (reify MessageHandler
                (handle-message [_ message]
                  (stream/put! messages message)))}))

(defn send-two-messages [system]
  (with-system system
    (let [{:keys [messages producer]} system]
      (producer/produce producer "One!")
      (producer/produce producer "Two!")
      (is (= "One!" @(stream/try-take! messages :drained-1 500 :timeout-1)))
      (is (= "Two!" @(stream/try-take! messages :drained-2 500 :timeout-2))))))

#_(deftest activemq
    (testing "Sending and receiving 2 messages with ActiveMQ."
      (send-two-messages (system {:bottle.messaging/broker-type :active-mq
                                  :bottle.messaging/broker-path "tcp://localhost:62626"
                                  :bottle.messaging/queue-name queue-name}))))

(deftest rabbitmq
  (testing "Sending and receiving 2 messages with RabbitMQ."
    (send-two-messages (system {:bottle.messaging/broker-type :rabbit-mq
                                :bottle.messaging/broker-path "localhost"
                                :bottle.messaging/queue-name queue-name}))))
(deftest stream
  (testing "Sending and receiving 2 messages with a Manifold stream."
    (let [config {:bottle.messaging/broker-type :stream
                  :bottle.messaging/stream :test
                  :bottle/streams [:test]}]
      (send-two-messages (-> config
                             (system)
                             (assoc :stream-manager (stream-manager/stream-manager config)))))))
