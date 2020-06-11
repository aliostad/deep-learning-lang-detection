(ns franzy.examples.consumer.state-management
  (:require [franzy.clients.consumer.client :as consumer]
            [franzy.clients.consumer.protocols :refer :all]
            [franzy.clients.consumer.defaults :as cd]
            [franzy.serialization.deserializers :as deserializers]
            [franzy.serialization.nippy.deserializers :as nippy-deserializers]
            [franzy.examples.configuration :as config]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; State Management
;;
;; This example demonstrates that a consumer can be paused and resumed as required. It can also be woken up to safely
;; terminate it from another thread if it is locked polling.
;;
;; From beyond:
;;
;; 1. Generally when you poll, you may end up blocking your thread. You should be polling in your own thread.
;; 2. Since your thread may be blocked, you need to wakeup a blocked consumer to close it. This demonstrates calling wakeup.
;; 3. Sometimes you want a consumer to just stop consuming without terminating the thread. You can call pause for this.
;; 4. You can achieve at least pausing to some degree just using core.async or manifold. I prefer to do this because
;;    I like to use core.async to manage my polling threads, and among other things, mute them, kill them and shut down
;; 5. You can pause or more partitions. This is the advantage of using the pause method as you can control per-partition
;;    which is a lot harder with your own implementation. If you're only polling 1 partition, then pause is less useful.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn manage-state []
  (let [cc {:bootstrap.servers config/kafka-brokers
            :group.id          "hungry-eels"
            :client.id         "ghost-with-most"
            :auto.offset.reset :earliest}
        key-deserializer (deserializers/keyword-deserializer)
        value-deserializer (nippy-deserializers/nippy-deserializer)
        options (cd/make-default-consumer-options)
        topic (:nippy-topic config/topics-to-create)
        first-topic-partition {:topic topic :partition 0}
        second-topic-partition {:topic topic :partition 1}
        topic-partitions [first-topic-partition second-topic-partition]]
    [(with-open [c (consumer/make-consumer cc key-deserializer value-deserializer options)]
       ;;first we'll make sure we can assign some partitions. We could also subscribe instead, but for examples, this is easier.
       (assign-partitions! c topic-partitions)
       (seek-to-beginning-offset! c topic-partitions)
       ;There comes a time when instead of being good citizens and using something like core.async, manifold, etc,
       ;we decide to use the Kafka consumer's notion of controlling things, because that sounds fun
       ;but it might be necessary if we want to avoid building some control by topic partition ourselvess
       (pause! c [first-topic-partition])
       ;;notice, we passed a vector, not a single topic partition, because normally you'll want to do this for more than one
       (println "Records polled after pause:" (take 5 (-> (poll! c)
                                                          (records-by-topic-partition topic 0))))
       ;;no records returned after we paused the topic partition, great!
       (resume! c [first-topic-partition])
       ;;pop-up your notifications, you should have results again.....
       (println "Records polled after resume:" (take 5 (-> (poll! c)
                                                           (records-by-topic-partition topic 0))))
       ;this normally involves another thread, but we won't complicate these examples
       ;we'll try to force a longer poll by pausing 2 topics here, then waking up
       ;Use this to wakeup a consumer performing a long poll, which will normally block your thread
       (pause! c topic-partitions)
       (poll! c)
       ;;you will normally want to call wakeup! from another thread, to ensure you can safely shut down your consumer
       (wakeup! c)
       ;;and if we imagine we are in another thread, we would also call close
       )]))
